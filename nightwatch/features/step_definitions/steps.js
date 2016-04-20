"use strict";
const _ = require("lodash");
const request = require('request-promise');
const cookie_jar = request.jar();
const rp = request.defaults({jar: cookie_jar, json: true});

module.exports = function () {
  this.Given(/^I open the wallboard$/, function () {
    this
      .init()
      .waitForElementVisible('body', 1000)
  })
  var browser = this;
  this.Given(/^I am an unauthenticated user$/, function () {
    this.deleteCookies();
  });

  this.Then(/^I should be redirected to login via keycloak$/, function () {
    this.expect.element("#username").to.be.visible.before(3000);
  });

  this.Then(/^I login$/, function () {
    this
      .setValue('#username', 'ircbdtestuser1')
      .setValue('#password', 'IRCBDBedManagement')
      .click("#kc-login");
    this.expect.element("h1").text.to.equal("IRC Bed Management").before(1000);

  });

  this.Then(/^I should be connected$/, function () {
    this.expect.element(".disconnected").to.not.present.after(2000);

  });

  this.Then(/^I show numbers of centre with id "([^"]*)"$/, function (centreId) {
    this.click('#centre-' + centreId + ' .detail-toggle');
  });

  this.Then(/^the centre with id "([^"]*)" has heading "([^"]*)"$/, function (centreId, centreName) {
    const headingSelector = `#centre-${centreId}>h3`;
    this.expect.element(headingSelector).text.to.equal(centreName).before(1000);
  });

  this.Given(/^I have authenticated$/, function (callback) {
      this
        .url(this.globals.backend_url)
        .getCookies(result => {
          cookie_jar.setCookie(rp.cookie(`kc-access=${result.value[0].value}`), this.globals.backend_url);
          this.globals["kc-access"] = result.value[0].value;
        });
    }
  );

  this.Then(/^There are no existing centres$/, function () {
    this.perform(function (client, done) {
      rp(`${client.globals.backend_url}/centres`)
        .then(body => body.data)
        .map(centre => rp({
          method: 'DELETE',
          uri: `${client.globals.backend_url}/centres/${centre.id}`,
        }))
        .finally(() => done());
    });
  });

  this.Then(/^The following centres exist:$/, function (table) {
    this.perform(function (client, done) {
      return _.map(table.hashes(), (row) =>
        rp({
          method: 'POST',
          uri: `${client.globals.backend_url}/centres`,
          body: {
            name: row.name,
            male_capacity: parseInt(row.male_capacity),
            female_capacity: parseInt(row.female_capacity)
          },
          json: true
        })
          .then(() => done())
      )
    });
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

  this.Given(/^I submit a heartbeat with:$/, function (table) {
    this.perform(function (client, done) {
      let row = table.rowsHash();
      rp({
        method: 'POST',
        uri: `${client.globals.backend_url}/irc_entry/heartbeat`,
        body: {
          centre: row.centre,
          male_occupied: parseInt(row.male_occupied),
          female_occupied: parseInt(row.female_occupied),
          male_outofcommission: parseInt(row.male_outofcommission),
          female_outofcommission: parseInt(row.female_outofcommission)
        },
        json: true
      })
        .then(() => done())
    });
  });

};
