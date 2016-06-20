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

  this.Then(/^the Centre "([^"]*)" should show the following CIDS under "([^"]*)" "([^"]*)"(, which should be clickable)?:$/, function (centreName, gender, detail, clickable, table) {
    // @TODO: add something to test order
    if (typeof table === 'function') {
      table = clickable
      clickable = false
    }
    this.page.wallboard().toggleCentreDetails(centreName, gender)
    this.page.wallboard().toggleCentreDetailsCid(centreName, gender, detail)
    _.map(table.hashes(), (row, index) =>
      this.page.wallboard().expectCentreDetailCids(centreName, gender, detail, index + 1, row['CID Person ID'], clickable)
    )
    this.page.wallboard().toggleCentreDetailsCid(centreName, gender, detail)
    this.page.wallboard().toggleCentreDetails(centreName, gender)
  })
}
