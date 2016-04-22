"use strict";

const getCentreGenderScope = (centre_name, gender) => `//h3/text()[contains(., "${centre_name}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]`;

module.exports = {
  commands: [{
    toggleCentreDetails: function (centre_name, gender) {
      let centreToggle = `${getCentreGenderScope(centre_name, gender)}//a[contains(@class, "detail-toggle")]`;
      this.api
        .useXpath()
        .expect.element(centreToggle).to.be.present.after(1000);
      this.api
        .click(centreToggle)
        .useCss();
    },
    expectCentreDetail: function (centre_name, gender, k, v) {
      this.api.useXpath();
      this.expect.element(`${getCentreGenderScope(centre_name, gender)}//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).before(1000);
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