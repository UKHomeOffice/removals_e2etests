/* global rp cookie_jar */
'use strict'

module.exports = function () {
  this.Given(/^I am a logged in user$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this
      .url(this.globals.backend_url)
      .deleteCookies()

    this.page.login().dologin(process.env.KEYCLOAK_USER, process.env.KEYCLOAK_PASS)

    this
      .url(this.globals.backend_url)
      .getCookie('kc-access', result =>
        cookie_jar.setCookie(rp.cookie(`kc-access=${result.value}`), this.globals.backend_url)
      )
  })

  this.Given(/^I am an unauthenticated user$/, function () {
    this.deleteCookies()
  })

  this.Then(/^I should be redirected to login via keycloak$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this.page.login().expect.element('@username').to.be.visible.before(5000)
  })

  this.Then(/^I login$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this.page.login().dologin('ircbdtestuser1', 'IRCBDBedManagement')

    this.page.wallboard().expect.element('@title').text.to.equal('IRC Bed Management').before(1000)
  })
}
