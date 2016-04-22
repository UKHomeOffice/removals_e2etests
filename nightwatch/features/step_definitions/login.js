"use strict";

module.exports = function () {
  this.Given(/^I am a logged in user$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this
      .deleteCookies()
      .url(this.globals.backend_url)

    this.page.login().dologin("ircbdtestuser1", "IRCBDBedManagement");

    this
      .url(this.globals.backend_url)
      .getCookies(result => {
        cookie_jar.setCookie(rp.cookie(`kc-access=${result.value[0].value}`), this.globals.backend_url);
      });
  });

  this.Given(/^I am an unauthenticated user$/, function () {
    this.deleteCookies();
  });

  this.Then(/^I should be redirected to login via keycloak$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this.page.login().expect.element("@username").to.be.visible.before(3000);
  });

  this.Then(/^I login$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this.page.login().dologin("ircbdtestuser1", "IRCBDBedManagement");

    this.page.wallboard().expect.element("@title").text.to.equal("IRC Bed Management").before(1000);
  });

}
