"use strict";

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

}
