'use strict'

const getCentreGenderScope = (centreName, gender) => `//h3/text()[contains(., "${centreName}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]`

module.exports = {
  commands: [{
    toggleCentreDetails: function (centreName, gender) {
      let centreToggle = `${getCentreGenderScope(centreName, gender)}//a[contains(@class, "detail-toggle")]`
      this.api
        .useXpath()
        .expect.element(centreToggle).to.be.present.after(5000)
      this.api
        .click(centreToggle)
        .useCss()
    },
    toggleCentreDetailsNested: function (centreName, gender, k) {
      let centreDetailNestedToggle = `${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr`
      this.api
        .useXpath()
        .expect.element(centreDetailNestedToggle).to.be.present.after(2000)
      this.api
        .click(centreDetailNestedToggle)
        .useCss()
    },
    expectCentreDetail: function (centreName, gender, k, v, toNotBePresent) {
      let centreDetail = `${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`
      this.api.useXpath()
      if (toNotBePresent) {
        this.expect.element(centreDetail).to.not.be.present.after(2000)
      } else if (v) {
        this.expect.element(centreDetail).text.to.equal(v).before(2000)
      } else {
        this.expect.element(centreDetail).to.be.present.after(2000)
      }
      this.api.useCss()
    }
  }],
  elements: {
    title: {
      selector: 'h1'
    },
    disconnected_message: {
      selector: '.disconnected'
    }
  }
}
