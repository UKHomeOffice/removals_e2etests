"use strict";

module.exports = {
  commands: [{
    toggleCentreDetails: function (centre_name, gender) {
      let centreToggle = `//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//a[contains(@class, "detail-toggle")]`;
      this.api.useXpath();
      this.expect.element(centreToggle).to.be.present.after(1000);
      this.click(centreToggle);
      this.api.useCss();
    },
    expectCentreDetail: function (centre_name, gender, k, v) {
      this.api.useXpath();
      this.expect.element(`//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).before(1000);
      this.api.useCss();
    }
  }],
  elements: {
    title: {
      selector: "h1"
    },
    disconnected_message: {
      selector: ".disconnected"
    }
  }
};