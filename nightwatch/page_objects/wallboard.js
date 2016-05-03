'use strict'

const getCentreGenderScope = (centreName, gender) => `//h3/text()[contains(., "${centreName}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]`

module.exports = {
  commands: [{
    toggleCentreDetails: function (centreName, gender) {
      let centreToggle = `${getCentreGenderScope(centreName, gender)}//a[contains(@class, "detail-toggle")]`
      this.api
        .useXpath()
        .expect.element(centreToggle).to.be.present.after(1000)
      this.api
        .click(centreToggle)
        .useCss()
    },
    expectCentreDetail: function (centreName, gender, k, v) {
      this.api.useXpath()
      this.expect.element(`${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).before(1000)
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
