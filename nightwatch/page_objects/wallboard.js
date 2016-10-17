'use strict'

// const getCentreGenderScope = (centreName, gender) => `//h3/text()[contains(., "${centreName}")]/ancestor::div[contains(@class, "centre")]/centre-gender-directive[@gender="'${gender}'"]`

const getCentreScope = (centreName) => `//h3/text()[contains(., "${centreName}")]/ancestor::li[contains(@class, "centre")]//div`

module.exports = {
  commands: [{
    toggleCentreDetailsNested: function (centreName, k) {
      const centreDetailNestedToggle = `${getCentreScope(centreName)}//th[contains(., "${k}")]/ancestor::tr`
      this.api
        .useXpath()
        .expect.element(centreDetailNestedToggle).to.be.present.after(5000)
      this.api
        .click(centreDetailNestedToggle)
      this.api.useCss()
    },

    expectCentreDetail: function (centreName, gender, k, v) {
      let centreDetail = `${getCentreScope(centreName)}//*/text()[contains(., "${k}")]/ancestor::tr//td[contains(@class, " ${gender.toLowerCase()}")]`
      this.api.useXpath()
        .expect.element(centreDetail).text.to.equal(v).before(5000)
      this.api.useCss()
    },

    expectCentreDetailCids: function (centreName, gender, k, i, cid) {
      const listItem = `${getCentreScope(centreName)}//th/text()[contains(., "${k}")]/ancestor::tr/following-sibling::tr[contains(@class, "detail")]//ul[contains(@aria-label, "${gender} CIDs")]/li[${i}]`
      this.api.useXpath()
        .expect.element(listItem).text.to.contain(cid).before(2000)
      this.api.useCss()
    },

    expectCentreUnexpectedCids: function (centreName, gender, i, cid) {
      const listItem = `${getCentreScope(centreName)}//div[contains(@class, "unexpected ${gender}")]//li[${i}]`
      this.api.useXpath()
        .expect.element(listItem).text.to.contain(cid).before(2000)
      this.api.useCss()
    },

    expectCentreUnexpectedCount: function (centreName, gender, count) {
      const list = `${getCentreScope(centreName)}//div[contains(@class, "unexpected ${gender}")]`
      if (count === 0) {
        this.api.useXpath()
          .expect.element(list).to.not.be.present.after(2000)
      } else {
        this.api.useXpath()
          .expect.element(`${list}//li[${count}]`).to.be.present.before(2000)
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
    },
    reports_from: '#from',
    reports_to: '#to',
    reports_get_summary: '#getSummary',
    reports_get_raw: '#getRaw'
  }
}
