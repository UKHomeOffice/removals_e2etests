/* global rp _ */
'use strict'
require('sugar-date')

const eventPost = function (operation, table, requestDecorator) {
  let tablehashes = table.rowsHash()
  tablehashes.operation = operation
  tablehashes.timestamp = Date.create(tablehashes.timestamp || 'now').toISOString()

  if (tablehashes.cid_id) {
    tablehashes.cid_id = parseInt(tablehashes.cid_id)
  }

  if (tablehashes.person_id) {
    tablehashes.person_id = parseInt(tablehashes.person_id)
  } else if (tablehashes.single_occupancy_person_id) {
    tablehashes.single_occupancy_person_id = parseInt(tablehashes.single_occupancy_person_id)
  }

  if (!requestDecorator) {
    requestDecorator = (req) => req
  }
  return this.perform((client, done) =>
    requestDecorator(
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/irc_entry/event`,
        body: tablehashes,
        jar: false
      })
        .finally(() => done())
    )
  )
}

module.exports = function () {
  this.When(/^I submit the following movements:$/, function (table) {
    let payload = _.map(table.hashes(), (row) => {
      row['CID Person ID'] = parseInt(row['CID Person ID'])
      row['MO Ref'] = parseInt(row['MO Ref'])
      row['MO Date'] = Date.create(row['MO Date'] || 'now').set({hour: 12}).format('{dd}/{MM}/{yyyy} {H}:{mm}:{ss}')
      return row
    })

    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/cid_entry/movement`,
        body: {cDataSet: payload}
      })
        .finally(() => done())
    )
  })

  this.When(/^I submit the following "([^"]*)" event:$/, function (operation, table) {
    return eventPost.call(this, operation, table)
  })

  this.When(/^I submit the following "([^"]*)" event expecting a "([^"]*)" error:$/, function (operation, expectedStatus, table) {
    var didError = false
    var actualStatus
    return eventPost.call(this, operation, table, (request) =>
      request.catch(Error, error => (didError = true) && (actualStatus = error.statusCode))
        .finally(() => this.assert.ok(didError, 'An error occurred'))
        .finally(() => this.assert.ok(actualStatus.toString() === expectedStatus.toString(), `Status "${actualStatus}" was as expected "${expectedStatus}"`))
    )
  })

  this.When(/^The following detainee exists:$/, function (table) {
    return eventPost.call(this, 'update individual', table)
  })

  this.When(/^I submit the following prebookings:$/, function (table) {
    let payload = _.map(table.hashes(), (row) => {
      row.cid_id = parseInt(row.cid_id) || 0
      row.timestamp = Date.create(row.timestamp || 'today 8am').toISOString()
      return row
    })
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/depmu_entry/prebooking`,
        body: {cDataSet: payload}
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
