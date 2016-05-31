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
    toggleCentreDetailsCid: function (centreName, gender, k) {
      let centreDetailCidToggle = `${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr`
      this.api
        .useXpath()
        .expect.element(centreDetailCidToggle).to.be.present.after(2000)
      this.api
        .click(centreDetailCidToggle)
        .useCss()
    },
    expectCentreDetail: function (centreName, gender, k, v) {
      this.api.useXpath()
      this.expect.element(`${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr/td[last()]`).text.to.equal(v).before(2000)
      this.api.useCss()
    },
    expectCentreDetailCids: function (centreName, gender, k, i, cid) {
      this.api.useXpath()
      this.expect.element(`${getCentreGenderScope(centreName, gender)}//td/text()[contains(., "${k}")]/ancestor::tr//ul/li[${i}]`).text.to.contain(cid).before(2000)
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
