'use strict'

module.exports = function () {
  this.Given(/^I am a logged in user$/, function () {
    if (this.globals.auth_required === false) {
      return true
    }
    this
      .url(this.globals.backend_url)

    this.page.login().dologin(process.env.KEYCLOAK_USER, process.env.KEYCLOAK_PASS)
  })

  this.Given(/^I am an unauthenticated user$/, function () {
    this
      .url(this.globals.backend_url)
      .deleteCookies()
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
    this.page.login().dologin(process.env.KEYCLOAK_USER, process.env.KEYCLOAK_PASS)

    this.page.wallboard().expect.element('@title').text.to.equal('IRC Capacity Management').before(1000)
  })
}
