/* global _ rp */
'use strict'

const Promise = require('bluebird')
const moment = require('moment-timezone')
const jsf = require('json-schema-faker')
const socketIOClient = require('socket.io-client')
const sailsIOClient = require('sails.io.js')

moment.tz.setDefault('Europe/London')

const operation = {
  heartbeat: { singular: true, url: 'irc_entry/heartbeat' },
  event: { singular: true, url: 'irc_entry/event' },
  movement: { singular: false, url: 'cid_entry/movement' },
  prebooking: { singular: false, url: 'depmu_entry/prebooking' }
}

const getMsSince = (startTime) => parseInt(new Date() - startTime)

const getSchema = (context, urlEndpoint) => rp({
  method: 'OPTIONS',
  uri: `${context.globals.backend_url}/${urlEndpoint}`
})
  .then(response => response.data)

const generateFakes = (schema, fakes, quantityOfFakes) => {
  let alteredFakes = {}
  _.mapKeys(fakes, (fake, key) => {
    if (!_.isFunction(fake)) {
      fakes[key] = () => fake
    }
    _.set(alteredFakes, key, fake)
    _.set(schema, `properties.${key}.faker`, `custom.${key}`)
  })
  jsf.extend('faker', function (faker) {
    faker.custom = alteredFakes
    return faker
  })
  return _.map(_.range(quantityOfFakes), () => jsf(schema))
}

const alterSchema = (schema, type, quantityOfFakes) => {
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

  this.Then(/^all the socket clients should have received "([^"]*)" message each$/, function (count) {
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

  this.Then(/^The browser memory should not have increased by more than ([^"]*)mb$/, function (megabytes) {
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

  this.When(/^I submit "([^"]*)" random "([^"]*?)s?"(?: every "([^"]*)" minutes? for "([^"]*)" minutes? all taking less than "([^"]*)" milliseconds each|)$/, function (count, type, interval, duration, threshold) {
    console.log(count, type, interval, duration, threshold)
    let urlEndpoint = operation[type].url

    let quantityOfFakes = operation[type].singular ? 1 : count;
    let delayBetweenPosts = false;
    if (interval && duration) {
      interval = /single/i.test(interval) ? 1 : interval;
      quantityOfFakes *= (interval * duration);
      delayBetweenPosts = ((duration * 60000) / interval) / quantityOfFakes;
    }

    let fakes = {}
    if (type === 'heartbeat') {
      fakes = {
        centre: () => _.sample(_.map(this.centres, 'name'))
      }
    }
    if (type === 'movement') {
      let MOcounter = 100;
      fakes = {
        'Output.items.properties.Location': () => _.sample(_.merge(_.map(this.centres, 'male_cid_name'), _.map(this.centres, 'female_cid_name'))),
        'Output.items.properties.MO Date': () => '05/01/2016 00:01:00',
        'Output.items.properties.MO In/MO Out': () => _.sample(['in', 'out']),
        'Output.items.properties.MO Type': () => _.sample(['Occupancy', 'Non-Occupancy', 'Removal']),
        'Output.items.properties.MO Ref': () => (++MOcounter).toString(),
        'Output.items.properties.CID Person ID': () => _.random(100, 1000000).toString()
      }
    }
    if (type === 'prebooking') {
      fakes = {
        'Output.items.properties.location': () => _.sample(_.merge(_.map(this.centres, 'male_cid_name'), _.map(this.centres, 'female_cid_name'))),
        'Output.items.properties.timestamp': () => moment().set({ hour: 7, minute: 0, second: 0 }).format(),
        'Output.items.properties.cid_id': () => _.random(100, 1000000).toString()
      }
    }

    let i = 1, uri = `${this.globals.backend_url}/${urlEndpoint}`;
    this.promises = this.promises || [];
    this.perform((client, done) => {
      let startTime = new Date()
      let prom = getSchema(this, urlEndpoint)
        .tap(schema => this.assert.ok(schema !== false, `Got ${type} schema in ${getMsSince(startTime)} milliseconds`))
        .then(schema => alterSchema(schema, type, count))
        .then(schema => generateFakes(schema, fakes, quantityOfFakes))
        .tap(fakes => this.assert.ok(!_.isEmpty(fakes), `Generated ${quantityOfFakes} fake ${type} payloads in ${getMsSince(startTime)} milliseconds`))
        .tap(() => done())
        .each(payload => {
          let startTime = new Date()
          console.log(delayBetweenPosts) //WTF???
          return rp({
            method: 'POST',
            uri: uri,
            timeout: 999999999,
            body: payload
          })
            .then(() => getMsSince(startTime))
            .tap((time) => delayBetweenPosts && this.assert.ok(time < threshold, `Backend ${type} request ${i++} took ${time} milliseconds sleeping for ${((delayBetweenPosts - time) / 1000).toFixed(2)} seconds`))
            .tap((time) => delayBetweenPosts && Promise.delay(delayBetweenPosts - time))
        });
      this.promises.push(prom);
    })
  })
}
