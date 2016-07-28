/* global _ rp */
'use strict'

const Promise = require('bluebird')
const moment = require('moment-timezone')
const jsf = require('json-schema-faker')
const socketIOClient = require('socket.io-client')
const sailsIOClient = require('sails.io.js')
const retry = require('bluebird-retry')

moment.tz.setDefault('Europe/London')

const operation = {
  heartbeat: {singular: true, url: 'irc_entry/heartbeat'},
  event: {singular: true, url: 'irc_entry/event'},
  movement: {singular: false, url: 'cid_entry/movement'},
  prebooking: {singular: false, url: 'depmu_entry/prebooking'}
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

const makeSocketClient = (io) => rp({
  followRedirect: false,
  uri: io.sails.url,
  jar: false,
  resolveWithFullResponse: true
})
  .catch((response) => _.get(response, 'response.headers.set-cookie[0]', ''))
  .then((routecookie) => {
    io.sails.initialConnectionHeaders.Cookie = `kc-access=${global.kcaccesscookie}; ${routecookie}`
    return new Promise((resolve, reject) => {
      let socket = io.sails.connect()
      socket.messages = []
      socket.get('/centres', (body, JWR) => {
        socket.on('centres', (message) => socket.messages.push(message))
        resolve(socket)
      })
    })
  })

module.exports = function () {
  this.Given(/^I capture the browser memory footprint$/, function () {
    this.browser_memory_footprint = this.browser_memory_footprint || []
    return this.execute('gc(); return window.performance.memory', [], (result) =>
      this.browser_memory_footprint.push(result.value.totalJSHeapSize)
    )
  })

  this.Given(/^I spawn "([^"]*)" socket clients to the backend$/, function (count) {
    this.perform((client, done) => {
      delete socketIOClient.sails
      let io = sailsIOClient(socketIOClient)
      io.sails.autoConnect = false
      io.sails.url = this.globals.backend_url
      io.sails.transports = ['polling']
      io.sails.initialConnectionHeaders = {
        nosession: true
      }
      io.sails.environment = 'production'
      var counter = 1
      this.socketClients = Promise.map(
        _.range(count),
        (item, index, length) => retry(
          () => makeSocketClient(io)
            .timeout(30000),
          {
            max_tries: 10
          }
        )
          .catch(Promise.TimeoutError, () => Promise.resolve(false))
          .tap(socket => console.log(`Client ${counter++} of ${length} ${socket ? 'connected' : 'failed'}`)),
        {concurrency: 10}
      )
        .then(sockets => this.assert.equal(_.compact(sockets).length, count, `${count} sockets opened`))
        .finally(done)
    })
  })

  this.Then(/^all the socket clients should have received "([^"]*)" message each$/, function (count) {
    let i = 0
    this.perform((client, done) => {
      client.socketClients
        .map(socket => {
          i++
          this.assert.equal(socket.messages.length, count, `Socket [${i}] received ${socket.messages.length} messages`)
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

  this.When(/^I submit "([^"]*)" random "([^"]*)s" every "([^"]*)" minute for "([^"]*)" minutes all taking less than "([^"]*)" milliseconds each$/, function (count, type, interval, duration, threshold) {
    let urlEndpoint = operation[type].url

    let quantityOfFakes = count * (interval * duration)
    let MOcounter = 100
    let fakes = {}
    if (type === 'heartbeat') {
      fakes = {
        centre: () => _.sample(_.map(this.centres, 'name'))
      }
    }
    if (type === 'event') {
      fakes = {
        centre: () => _.sample(_.map(this.centres, 'name'))
      }
    }
    if (type === 'movement') {
      fakes = {
        'Output.items.properties.Location': () => _.sample(_.merge(_.map(this.centres, 'male_cid_name'), _.map(this.centres, 'female_cid_name'))),
        'Output.items.properties.MO Date': () => '05/01/2016 00:01:00',
        'Output.items.properties.MO In/MO Out': () => _.sample(['in', 'out']),
        'Output.items.properties.MO Type': () => _.sample(['Occupancy', 'Non-Occupancy', 'Removal']),
        'Output.items.properties.MO Ref': () => {
          MOcounter++
          return MOcounter.toString()
        },
        'Output.items.properties.CID Person ID': () => _.random(100, 1000000).toString()
      }
    }
    if (type === 'prebooking') {
      fakes = {
        'Output.items.properties.location': () => _.sample(_.merge(_.map(this.centres, 'male_cid_name'), _.map(this.centres, 'female_cid_name'))),
        'Output.items.properties.timestamp': () => moment().set({hour: 7, minute: 0, second: 0}).format(),
        'Output.items.properties.cid_id': () => _.random(100, 1000000).toString()
      }
    }

    if (!operation[type].singular) {
      quantityOfFakes = interval * duration
    }
    let delayBetweenPosts = ((duration * 60000) / interval) / quantityOfFakes

    let i = 1
    this.perform((client, done) => {
      let startTime = new Date()
      getSchema(this, urlEndpoint)
        .tap(schema => this.assert.ok(schema !== false, `Got ${type} schema in ${getMsSince(startTime)} milliseconds`))
        .then(schema => alterSchema(schema, type, count))
        .then(schema => generateFakes(schema, fakes, quantityOfFakes))
        .tap(fakes => this.assert.ok(!_.isEmpty(fakes), `Generated ${quantityOfFakes} fake ${type} payloads in ${getMsSince(startTime)} milliseconds`))
        .each(payload => {
          let startTime = new Date()
          return rp({
            method: 'POST',
            uri: `${this.globals.backend_url}/${urlEndpoint}`,
            timeout: 999999999,
            body: payload
          })
            .catch(() => {
            })
            .then(() => getMsSince(startTime))
            .tap((time) => this.assert.ok(time < threshold, `Backend ${type} request ${i} took ${time} milliseconds sleeping for ${((delayBetweenPosts - time) / 1000).toFixed(2)} seconds`))
            .tap(() => i++)
            .tap((time) => Promise.delay(delayBetweenPosts - time))
        })
        .then(done)
    })
  })
}
