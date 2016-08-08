/* global _  angular*/
'use strict'

require('sugar-date')

const csvparser = require('csv-parse')

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
    this.page.wallboard().toggleCentreDetailsNested(centreName, gender, detail)
    _.map(table.hashes(), (row, index) =>
      this.page.wallboard().expectCentreDetailCids(centreName, gender, detail, index + 1, row['CID Person ID'], clickable)
    )
    this.page.wallboard().toggleCentreDetailsNested(centreName, gender, detail)
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

  this.Then(/^The "(Summary|Raw)" Occupancy Report for "([^"]*)" should return:$/, function (report, day, table) {
    let fromDate = Date.create(day).beginningOfDay()
    let toDate = Date.create(day).endOfDay()

    this.page.wallboard()
      .expect.element('@reports_from').to.present.after(20000)

    this.page.wallboard()
      .sendKeys('@reports_from', fromDate.format('{dd}/{MM}/{yyyy}'))
      .sendKeys('@reports_to', toDate.format('{dd}/{MM}/{yyyy}'))

    this.timeoutsAsyncScript(1000)

    const assert = this.assert
    this.executeAsync(function (report, done) {
      angular.element(document.getElementById('getSummary'))
          .scope()[`$$child${report === 'Summary' ? 'Head' : 'Tail'}`]
          .buildCSV()
          .then(done)
    }, [report], response =>
        csvparser(response.value, {columns: true}, (err, parsedcsv) =>
          _.each(table.hashes(), (row) => assert.ok(_.find(parsedcsv, row), 'Matched csv to row'))
        )
    )
  })
}
