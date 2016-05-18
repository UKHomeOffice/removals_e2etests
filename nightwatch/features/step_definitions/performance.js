/* global _ rp */
'use strict'

const Promise = require('bluebird')
const moment = require('moment-timezone')
const jsf = require('json-schema-faker')
const socketIOClient = require('socket.io-client')
const sailsIOClient = require('sails.io.js')

moment.tz.setDefault('Europe/London')
require('sugar-date')

const operation = {
  heartbeat: {singular: true, url: 'irc_entry/heartbeat'},
  event: {singular: true, url: 'irc_entry/event'},
  movement: {singular: false, url: 'cid_entry/movement'},
  prebooking: {singular: false, url: 'depmu_entry/prebooking'}
}

const getMsSince = (startTime) => parseInt(new Date() - startTime)
const timeVthreshold = vs => vs > 0 ? `(+${vs})` : '';
const numberize = str => /single/i.test(str) ? 1 : parseInt(str);
const milliize = (units => unit => units[unit] || 1)({
  day: 24 * 60 * 60 * 1000,
  hour: 60 * 60 * 1000,
  minute: 60 * 1000,
  second: 1000
});

const getSchema = (context, urlEndpoint) => rp({
  method: 'OPTIONS',
  uri: `${context.globals.backend_url}/${urlEndpoint}`
})
  .then(response => response.data)

const fakers = centres => ({
  heartbeat: {
    centre: () => _.sample(_.map(centres, 'name'))
  },
  event: {
    centre: () => _.sample(_.map(centres, 'name')),
    timestamp: () => _.sample(_.map([
      Date.create('today 8am'),
      Date.create('yesterday 8am'),
      Date.create('one day before yesterday 8am')
    ], (date) => date.toISOString())),
  },
  movement: (MOcounter =>
    ({
      'Output.items.properties.Location': () => _.sample(_.concat(_.map(centres, 'male_cid_name'), _.map(centres, 'female_cid_name'))),
      'Output.items.properties.MO Date': () => _.sample(_.map([
        Date.create('today 8am'),
        Date.create('yesterday 8am'),
        Date.create('one day before yesterday 8am')
      ], (date) => date.format("{dd}/{MM}/{yyyy} {HH}:{mm}:{ss}"))),
      'Output.items.properties.MO In/MO Out': () => _.sample(['in', 'out']),
      'Output.items.properties.MO Type': () => _.sample(['Occupancy', 'Non-Occupancy', 'Removal']),
      'Output.items.properties.MO Ref': () => (++MOcounter).toString(),
      'Output.items.properties.CID Person ID': () => _.random(100, 1000000).toString()
    }))(100),
  prebooking: {
    'Output.items.properties.location': () => _.sample(_.concat(_.map(centres, 'female_cid_name'), _.map(centres, 'male_cid_name'))),
    'Output.items.properties.timestamp': () => moment().set({hour: 7, minute: 0, second: 0}).format(),
    'Output.items.properties.cid_id': () => _.random(100, 1000000).toString()
  }
});

const generateFakes = (schema, fakers, numberOfPosts) => {
  let alteredFakes = {}
  _.mapKeys(fakers, (fake, key) => {
    if (!_.isFunction(fake)) {
      fakers[key] = () => fake
    }
    _.set(alteredFakes, key, fake)
    _.set(schema, `properties.${key}.faker`, `custom.${key}`)
  })
  jsf.extend('faker', function (faker) {
    faker.custom = alteredFakes
    return faker
  })
  return _.map(_.range(numberOfPosts), () => jsf(schema))
}

const alterSchema = (schema, type, quantityOfFakes) => {
  if (type === 'event') {
    schema.definitions.operation.faker = 'custom.operation'
    schema.oneOf = [_.find(schema.oneOf, {"description": "Check in event"})];
  }
  if (type === 'movement') {
    schema.properties.Output.minItems = quantityOfFakes
    schema.properties.Output.maxItems = quantityOfFakes
    schema.properties.Output.items.properties['MO Ref.'].faker = 'custom.Output.items.properties.MO Ref'
    delete schema.properties.additionalProperties
  }
  if (type === 'prebooking') {
    schema.properties.Output.minItems = quantityOfFakes
    schema.properties.Output.maxItems = quantityOfFakes
    delete schema.properties.additionalProperties
  }
  return schema
}

const makeSocketClient = (context, io) => new Promise((resolve, reject) => {
  let socket = io.sails.connect()

  socket.messages = []

  socket.get('/centres', (body, JWR) => {
    socket.on('centres', (message) => socket.messages.push(message))
    resolve(socket)
  })
})

module.exports = function () {
  this.Given(/^I capture the browser memory footprint$/, function () {
    this.browser_memory_footprint = this.browser_memory_footprint || []
    return this.execute('gc(); return window.performance.memory', [], (result) =>
      this.browser_memory_footprint.push(result.value.totalJSHeapSize)
    )
  })

  this.Then(/^I wait for all that to finish$/, function () {
    this.perform((client, done) => {
      Promise.each(this.promises)
        .then(done)
    })

  })

  this.Given(/^I spawn (?:a single|"([^"]*)") socket clients? to the backend$/, function (count) {
    count = count || 1;
    this.perform((client, done) => {
      delete socketIOClient.sails
      let io = sailsIOClient(socketIOClient)
      io.sails.autoConnect = false
      io.sails.url = this.globals.backend_url
      io.sails.transports = ['polling']
      io.sails.initialConnectionHeaders = {
        nosession: true,
        Cookie: `route=${this.routecookie}; kc-access=${this.kcaccesscookie}`
      }
      io.sails.environment = 'production'
      this.socketClients = Promise.all(_.map(_.range(count), () => makeSocketClient(this, io)))
        .tap(sockets => this.assert.equal(sockets.length, count, `${count} sockets opened`))
        .finally(done)
    })
  })

  this.Then(/^all the socket clients should have received "([^"]*)" messages? each$/, function (count) {
    let i = 0
    this.perform((client, done) => {
      client.socketClients
        .map(socket => {
          i++
          this.assert.equal(count, socket.messages.length, `Socket [${i}] received ${socket.messages.length} messages`)
        })
        .finally(done)
    })
  })

  this.Then(/^The browser memory should not have increased by more than (\d+)mb$/, function (megabytes) {
    this.perform((client, done) => {
      client.assert.ok(this.browser_memory_footprint.length >= 2, `${this.browser_memory_footprint.length} memory footprints to use`)
      let before = this.browser_memory_footprint[0]
      let after = this.browser_memory_footprint[this.browser_memory_footprint.length - 1]
      let delta = after - before
      let deltaInMb = delta / 1000000
      client.assert.ok(deltaInMb < megabytes, `Browser memory increase is ${deltaInMb.toFixed(2)}mb`)
      done()
    })
  })

  this.When(/^I simulate "([^"]+)" (\w+?)s? with the following updates:$/, function (duration, durationUnit, table) {
    duration = numberize(duration) * milliize(durationUnit);
    const fakerz = fakers(this.centres);
    this.perform((client, done) => {
      Promise.all(table.hashes().map(row => {
        const fakesPerPost = operation[row.type].singular ? 1 : row.quantity;
        const delayBetweenPosts = Math.floor((numberize(row.interval) * milliize(row.intervalUnit)) / (operation[row.type].singular ? row.quantity : 1));
        const numberOfPosts = Math.floor(duration / delayBetweenPosts);

        const threshold = numberize(row.limit) * milliize(row.limitUnit);

        const urlEndpoint = operation[row.type].url;
        const uri = `${this.globals.backend_url}/${urlEndpoint}`;
        const startTime = new Date();

        return getSchema(this, urlEndpoint)
          .tap(schema => this.assert.ok(schema !== false, `Got ${row.type} schema in ${getMsSince(startTime)} milliseconds`))
          .then(schema => alterSchema(schema, row.type, fakesPerPost))
          .then(schema => generateFakes(schema, fakerz[row.type], numberOfPosts))
          .tap(fakes => this.assert.ok(!_.isEmpty(fakes), `Generated ${fakes.length} fake ${row.type} payloads in ${getMsSince(startTime)} milliseconds`))
          .each((payload, i, len) => {
            let postStartTime = new Date();
            return rp({
              method: 'POST',
              uri: uri,
              timeout: 999999999,
              body: payload
            })
              .then(_ => getMsSince(postStartTime))
              .tap(time => this.assert.ok(time < threshold, `Backend ${row.type} request ${i + 1} of ${len} took ${time}${timeVthreshold(time - threshold)} milliseconds sleeping for ${((delayBetweenPosts - time) / 1000).toFixed(2)} seconds`))
              .tap(time => Promise.delay(delayBetweenPosts - time));
          });
      })).finally(_ => done());
    });
  });
}
