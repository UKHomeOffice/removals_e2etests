/* global rp _ */
'use strict'
const moment = require('moment-timezone')
moment.tz.setDefault('Europe/London')
require('sugar-date')

const eventPost = function (operation, table) {
  let tablehashes = table.rowsHash()
  tablehashes.operation = operation
  tablehashes.timestamp = Date.create(tablehashes.timestamp || 'now').toISOString()

  if (tablehashes.cid_id) {
    tablehashes.cid_id = parseInt(tablehashes.cid_id)
  }

  if (tablehashes.person_id) {
    tablehashes.person_id = parseInt(tablehashes.person_id)
  }

  this.perform((client, done) =>
    rp({
      method: 'POST',
      uri: `${client.globals.backend_url}/irc_entry/event`,
      body: tablehashes,
      jar: false
    })
      .finally(() => done())
  )
}

module.exports = function () {
  this.When(/^I submit the following movements:$/, function (table) {
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/cid_entry/movement`,
        body: {Output: table.hashes()}
      })
        .finally(() => done())
    )
  })

  this.When(/^I submit the following "([^"]*)" event:$/, function (operation, table) {
    return eventPost.call(this, operation, table)
  })

  this.When(/^The following detainee exists:$/, function (table) {
    return eventPost.call(this, 'update individual', table)
  })

  this.When(/^I submit the following prebookings:$/, function (table) {
    var validTimestamp = moment().set({hour: 7, minute: 0, second: 0}).format()
    var pastTimestamp = moment(validTimestamp).subtract(1, 'millisecond').format()
    var futureTimestamp = moment(validTimestamp).add(1, 'day').format()
    let payload = _.map(table.hashes(), (row) => {
      switch (row.timestamp) {
        case 'beforeToday7am':
          row.timestamp = pastTimestamp
          break
        case 'afterTomorrow7am':
          row.timestamp = futureTimestamp
          break
        case 'betweenToday7amAndTomorrow7am':
          row.timestamp = validTimestamp
      }

      return row
    })
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/depmu_entry/prebooking`,
        body: {Output: payload}
      })
        .finally(() => done())
    )
  })

  this.Given(/^I submit a heartbeat with:$/, function (table) {
    let heartbeat = table.rowsHash()
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/irc_entry/heartbeat`,
        body: {
          centre: heartbeat.centre,
          male_occupied: parseInt(heartbeat.male_occupied),
          female_occupied: parseInt(heartbeat.female_occupied),
          male_outofcommission: parseInt(heartbeat.male_outofcommission),
          female_outofcommission: parseInt(heartbeat.female_outofcommission)
        },
        jar: false
      })
        .finally(() => done())
    )
  })

  this.Then(/^There are no existing centres$/, function () {
    this.perform((client, done) =>
      rp(`${client.globals.backend_url}/centres`)
        .then(body => body.data)
        .map(centre => rp({
          method: 'DELETE',
          uri: `${client.globals.backend_url}/centres/${centre.id}`
        }))
        .finally(() => done())
    )
  })

  this.Then(/^The following centres exist:$/, function (table) {
    this.centres = table.hashes()
    _.map(table.hashes(), (row) =>
      this.perform((client, done) =>
        rp({
          method: 'POST',
          uri: `${client.globals.backend_url}/centres`,
          body: {
            name: row.name,
            male_capacity: parseInt(row.male_capacity) || 0,
            female_capacity: parseInt(row.female_capacity) || 0,
            female_cid_name: row.female_cid_name ? row.female_cid_name.split(',') : [],
            male_cid_name: row.male_cid_name ? row.male_cid_name.split(',') : []
          }
        })
          .finally(() => done())
      )
    )
  })
}
