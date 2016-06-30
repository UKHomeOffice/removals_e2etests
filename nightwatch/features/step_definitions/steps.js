/* global _ */
'use strict'

module.exports = function () {
  this.Given(/^I am on the wallboard$/, function () {
    this.init()
  })

  this.Then(/^I should be connected$/, function () {
    this.page.wallboard().expect.element('@disconnected_message').to.not.present.after(2000)
  })

  this.Then(/^The Centre "([^"]*)" should show the following under "([^"]*)":$/, function (centreName, gender, table) {
    this.page.wallboard().toggleCentreDetails(centreName, gender)
    _.map(table.rowsHash(), (v, k) =>
      this.page.wallboard().expectCentreDetail(centreName, gender, k, v)
    )
    this.page.wallboard().toggleCentreDetails(centreName, gender)
  })
  
  this.Then(/^the Centre "([^"]*)" should( not)? show the following Reasons under "([^"]*)" "([^"]*)":$/, function (centreName, elementNotToBePresent, gender, detail, table) {
    this.page.wallboard().toggleCentreDetails(centreName, gender)
    this.page.wallboard().toggleCentreDetailsNested(centreName, gender, detail)
    _.map(table.rowsHash(), (v, k) =>
      this.page.wallboard().expectCentreDetail(centreName, gender, k, v, elementNotToBePresent)
    )
    this.page.wallboard().toggleCentreDetailsNested(centreName, gender, detail)
    this.page.wallboard().toggleCentreDetails(centreName, gender)
  })
}
