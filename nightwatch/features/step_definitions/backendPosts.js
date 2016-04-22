"use strict";
const moment = require('moment-timezone');
moment.tz.setDefault("Europe/London");

module.exports = function () {

  this.When(/^I submit the following movements:$/, function (table, callback) {
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/cid_entry/movement`,
        body: {Output: table.hashes()},
      })
        .finally(done)
    );
  });

  this.When(/^I submit the following prebookings:$/, function (table) {
    let payload = _.map(table.hashes(), (row) => {
      row.timestamp = moment().set({hour: 10, minute: 0, second: 0}).format();
      return row;
    });
    this.perform((client, done) =>
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/depmu_entry/prebooking`,
        body: {Output: payload},
      })
        .finally(done)
    );
  });

  this.Given(/^I submit a heartbeat with:$/, function (table) {
    let heartbeat = table.rowsHash();
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
        .then(done)
    );
  });

  this.Then(/^There are no existing centres$/, function () {
    this.perform((client, done) =>
      rp(`${client.globals.backend_url}/centres`)
        .then(body => body.data)
        .map(centre => rp({
          method: 'DELETE',
          uri: `${client.globals.backend_url}/centres/${centre.id}`,
        }))
        .finally(done)
    );
  });

  this.Then(/^The following centres exist:$/, function (table) {
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
          .finally(done)
      )
    );
  });
}
