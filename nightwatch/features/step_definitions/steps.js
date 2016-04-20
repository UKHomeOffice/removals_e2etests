module.exports = function () {
  this.Given(/^I open the wallboard$/, function () {
    this
      .init()
      .waitForElementVisible('body', 1000)
  })

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
    this.expect.element("#username").to.not.present;
  });

  this.Then(/^I should be connected$/, function () {
    this.expect.element(".disconnected").to.not.present.after(2000);

  });

  this.Then(/^I show numbers of centre with id "([^"]*)"$/, function (centreId) {
    this.click('#centre-' + centreId + ' .detail-toggle');
  })

  this.Then(/^the centre with id "([^"]*)" has heading "([^"]*)"$/, function (centreId, centreName) {
    const headingSelector = `#centre-${centreId}>h3`;
    this.expect.element(headingSelector).text.to.equal(centreName).before(1000);
  })

};
