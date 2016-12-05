/* global _  angular*/
'use strict'

require('sugar-date')

module.exports = function () {
  this.Given(/^I am on the wallboard$/, function () {
    this.init()
  })

  this.Then(/^I should be connected$/, function () {
    this.page.wallboard().expect.element('@disconnected_message').to.not.present.after(2000)
  })

  this.Then(/^The Centre "([^"]*)" should show the following under "([^"]*)":$/, function (centreName, gender, table) {
    _.map(table.rowsHash(), (v, k) =>
      this.page.wallboard().expectCentreDetail(centreName, gender, k, v)
    )
  })

  this.Then(/^the Centre "([^"]*)" should show the following CIDS under "([^"]*)" "([^"]*)":$/, function (centreName, gender, detail, table) {
    this.page.wallboard().toggleCentreDetailsNested(centreName, detail)
    _.map(table.hashes(), (row, index) =>
      this.page.wallboard().expectCentreDetailCids(centreName, gender, detail, index + 1, row['CID Person ID'])
    )
    this.page.wallboard().toggleCentreDetailsNested(centreName, detail)
  })

  this.Then(/^the Centre "([^"]*)" should show the following Reasons under "([^"]*)" "([^"]*)":$/, function (centreName, gender, detail, table) {
    this.page.wallboard().toggleCentreDetailsNested(centreName, detail)
    _.map(table.rowsHash(), (v, k) =>
      this.page.wallboard().expectCentreDetail(centreName, gender, k, v)
    )
    this.page.wallboard().toggleCentreDetailsNested(centreName, detail)
  })

  this.Then(/^the Centre "([^"]*)" should show( the following)? "([^"]*)" Unexpected "([^"]*)" Check\-ins(:)?$/, function (centreName, hastable, count, gender, ignore, table) {
    this.page.wallboard().expectCentreUnexpectedCount(centreName, gender, parseInt(count))
    if (table.hashes) {
      _.map(table.hashes(), (row, index) =>
        this.page.wallboard().expectCentreUnexpectedCids(centreName, gender, index + 1, row['CID Person ID'])
      )
    } else {
      // in this case table may be the callback
      table()
    }
  })

  this.Then(/^The "([^"]*)" Report for "([^"]*)" should return:$/, function (report, day, table) {
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
      angular.element(document.getElementById(`get${report}`))
          .scope()[`get${report}`]()
          .then(done)
    }, [report], response => {
      let stringedValues = _.toArray(_.mapValues(response.value, row => _.mapValues(row, value => value ? value.toString() : '')))
      return _.each(table.hashes(), (row) => assert.ok(_.find(stringedValues, row), 'Matched csv to row'))
    }
    )
  })
}
