/* global rp cookie_jar */
module.exports = {
  before: function (done) {
    rp({
      method: 'POST',
      uri: `${this.backend_url}/oauth/login?username=${process.env.KEYCLOAK_USER}&password=${process.env.KEYCLOAK_PASS}`
    })
      .then(response =>
        cookie_jar.setCookie(rp.cookie(`kc-access=${response.access_token}`), this.backend_url)
      )
      .catch(() => {})
      .finally(done)
  }
}
