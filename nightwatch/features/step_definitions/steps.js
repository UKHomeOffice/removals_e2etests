"use strict";

module.exports = function () {

  this.Given(/^I am on the wallboard$/, function () {
    this.init()
  })

  this.Then(/^I should be connected$/, function () {
    this.page.wallboard().expect.element("@disconnected_message").to.not.present.after(2000);
  });

  this.Then(/^The Centre "([^"]*)" should show the following under "([^"]*)":$/, function (centre_name, gender, table) {
    this.page.wallboard().toggleCentreDetails(centre_name, gender);
    _.map(table.rowsHash(), (v, k) =>
      this.page.wallboard().expectCentreDetail(centre_name, gender, k, v)
    );
    this.page.wallboard().toggleCentreDetails(centre_name, gender);
  });

}
