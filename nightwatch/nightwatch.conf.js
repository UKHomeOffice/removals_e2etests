/* global request cookie_jar _ */
const seleniumServer = require('selenium-server')
const chromedriver = require('chromedriver')

const inDocker = process.env.SELENIUM_HOST !== undefined
const seleniumHost = process.env.SELENIUM_HOST || 'localhost'

global.request = require('request-promise')
global.cookie_jar = request.jar()
global.rp = request.defaults({jar: cookie_jar, json: true})
global._ = require('lodash')

const skiptags = () => {
  var tags = ['performance']
  return _.includes(process.argv, '--tag') ? undefined : tags
}

module.exports = {
  src_folders: [require('nightwatch-cucumber')({
    closeSession: 'afterScenario'
  })],
  globals_path: 'globalsModule.js',
  output_folder: 'reports',
  custom_commands_path: '',
  custom_assertions_path: '',
  page_objects_path: 'page_objects',
  live_output: false,
  disable_colors: false,

  selenium: {
    start_process: !inDocker,
    server_path: seleniumServer.path,
    log_path: 'reports',
    host: 'selenium',
    port: 4444,
    cli_args: {
      'webdriver.chrome.driver': chromedriver.path
    }
  },

  test_settings: {
    docker: {
      launch_url: 'http://frontend',
      globals: {
        backend_url: 'http://backend:8080'
      }
    },
    dev: {
      launch_url: 'https://wallboard-dev.notprod.ircbd.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-dev.notprod.ircbd.homeoffice.gov.uk',
        auth_required: true
      }
    },
    int: {
      launch_url: 'https://wallboard-int.notprod.ircbd.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-int.notprod.ircbd.homeoffice.gov.uk',
        auth_required: true
      }
    },
    uat: {
      launch_url: 'https://wallboard-uat.notprod.ircbd.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-uat.notprod.ircbd.homeoffice.gov.uk',
        auth_required: true
      }
    },

    default: {
      skiptags: skiptags(),
      launch_url: 'http://localhost:8000',
      globals: {
        auth_required: false,
        backend_url: 'http://localhost:8080'
      },
      selenium_port: 4444,
      selenium_host: seleniumHost,
      silent: true,
      skip_testcases_on_fail: false,
      screenshots: {
        enabled: true,
        on_failure: true,
        on_error: true,
        path: 'screenshots'
      },
      desiredCapabilities: {
        browserName: 'chrome',
        javascriptEnabled: true,
        acceptSslCerts: true,
        chromeOptions: {
          'args': ['--no-sandbox', '--js-flags=--expose-gc', '--enable-precise-memory-info']
        }
      }
    }

  }
}
