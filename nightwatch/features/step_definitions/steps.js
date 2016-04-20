module.exports = function () {
  this.Given(/^I open the wallboard$/, function () {
    this
      .url(this.launch_url)
      .waitForElementVisible('body', 1000)
  })

  this.Then(/^I show numbers of centre with id "([^"]*)"$/, function (centreId) {
    this.click('#centre-' + centreId + ' .detail-toggle');
  })

  this.Then(/^the centre with id "([^"]*)" has heading "([^"]*)"$/, function (centreId, centreName) {
    const headingSelector = `#centre-${centreId}>h3`;
    this.expect.element(headingSelector).text.to.equal(centreName).before(1000);
  })

};
