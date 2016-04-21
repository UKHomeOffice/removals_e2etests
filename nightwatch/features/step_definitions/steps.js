"use strict";
const _ = require("lodash");
const request = require('request-promise');
const cookie_jar = request.jar();
const rp = request.defaults({jar: cookie_jar, json: true});
const moment = require('moment-timezone');
moment.tz.setDefault("Europe/London");

module.exports = function () {

  this.Given(/^I am a logged in user$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this
      .deleteCookies()
      .url(this.globals.backend_url)
      .waitForElementVisible('#username', 1000)
      .setValue('#username', 'ircbdtestuser1')
      .setValue('#password', 'IRCBDBedManagement')
      .click("#kc-login")
      .url(this.globals.backend_url)
      .getCookies(result => {
        cookie_jar.setCookie(rp.cookie(`kc-access=${result.value[0].value}`), this.globals.backend_url);
        this.globals["kc-access"] = result.value[0].value;
      });
  });

  this.Given(/^I am an unauthenticated user$/, function () {
    this.deleteCookies();
  });

  this.Then(/^I should be redirected to login via keycloak$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this.expect.element("#username").to.be.visible.before(3000);
  });

  this.Then(/^I login$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this
      .setValue('#username', 'ircbdtestuser1')
      .setValue('#password', 'IRCBDBedManagement')
      .click("#kc-login");
    this.expect.element("h1").text.to.equal("IRC Bed Management").before(1000);

  });

  this.Given(/^I have authenticated$/, function (callback) {
      if (this.globals.auth_required === false) {
        return true
      }
      this
        .url(this.globals.backend_url)
        .getCookies(result => {
          cookie_jar.setCookie(rp.cookie(`kc-access=${result.value[0].value}`), this.globals.backend_url);
          this.globals["kc-access"] = result.value[0].value;
        });
    }
  );

  this.Given(/^I am on the wallboard$/, function () {
    this
      .init()
      .waitForElementVisible('body', 1000)
  })

  this.Then(/^I should be connected$/, function () {
    this.expect.element(".disconnected").to.not.present.after(2000);

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

  this.Then(/^The Centre "([^"]*)" should show the following under "([^"]*)":$/, function (centre_name, gender, table) {
    let centreToggle = `//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//a[contains(@class, "detail-toggle")]`;
    this.useXpath();
    this.expect.element(centreToggle).to.be.present.after(1000);
    this.click(centreToggle);
    _.map(table.rowsHash(), (v, k) =>
      this.expect.element(`//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).after(1000)
    );
    this.click(centreToggle);
    this.useCss();
  });

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

}
