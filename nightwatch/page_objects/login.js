module.exports = {
  commands: [{
    dologin: function (username, password) {
      return this.waitForElementVisible('@username', 1000)
        .setValue('@username', username)
        .setValue('@password', password)
        .click('@login')
        .waitForElementNotPresent('@username', 1000)
    }
  }],
  elements: {
    username: {
      selector: '#username'
    },
    password: {
      selector: '#password'
    },
    login: {
      selector: '#kc-login'
    }
  }
}
