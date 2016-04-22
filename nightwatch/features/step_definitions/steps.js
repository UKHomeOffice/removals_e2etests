"use strict";

module.exports = function () {

  this.Given(/^I am on the wallboard$/, function () {
    this
      .init()
      .waitForElementVisible('body', 1000)
  })

  this.Then(/^I should be connected$/, function () {
    this.expect.element(".disconnected").to.not.present.after(2000);

  });

  this.Then(/^The Centre "([^"]*)" should show the following under "([^"]*)":$/, function (centre_name, gender, table) {
    let centreToggle = `//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//a[contains(@class, "detail-toggle")]`;
    this.useXpath();
    this.expect.element(centreToggle).to.be.present.after(1000);
    this.click(centreToggle);
    _.map(table.rowsHash(), (v, k) =>
      this.expect.element(`//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).after(1000)
    );
    this.click(centreToggle);
    this.useCss();
  });

}
