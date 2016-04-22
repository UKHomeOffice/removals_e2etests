const seleniumServer = require('selenium-server')
const chromedriver = require('chromedriver')

const in_docker = process.env.SELENIUM_HOST !== undefined;
const selenium_host = process.env.SELENIUM_HOST || "localhost"

global.request = require('request-promise');
global.cookie_jar = request.jar();
global.rp = request.defaults({jar: cookie_jar, json: true});
global._ = require("lodash");

module.exports = {
  src_folders: [require('nightwatch-cucumber')()],
  output_folder: 'reports',
  custom_commands_path: '',
  custom_assertions_path: '',
  page_objects_path: '',
  live_output: false,
  disable_colors: false,

  selenium: {
    start_process: !in_docker,
    server_path: seleniumServer.path,
    log_path: 'reports',
    host: 'selenium',
    port: 4444,
    cli_args: {
      'webdriver.chrome.driver': chromedriver.path
    }
  },

  test_settings: {
    dev: {
      launch_url: 'https://wallboard-ircbd-dev.notprod.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-ircbd-dev.notprod.homeoffice.gov.uk',
        auth_required: true
      }
    },
    int: {
      launch_url: 'https://wallboard-ircbd-int.notprod.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-ircbd-int.notprod.homeoffice.gov.uk',
        auth_required: true
      }
    },
    uat: {
      launch_url: 'https://wallboard-ircbd-uat.notprod.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-ircbd-uat.notprod.homeoffice.gov.uk',
        auth_required: true
      },
    },

    default: {
      launch_url: 'http://localhost:8000',
      globals: {
        auth_required: false,
        backend_url: 'http://localhost:8080',
      },
      selenium_port: 4444,
      selenium_host: selenium_host,
      silent: true,
      // skip_testcases_on_fail: false,
      screenshots: {
        enabled: true,
        on_failure: true,
        on_error: true,
        path: 'screenshots/default'
      },
      desiredCapabilities: {
        browserName: 'chrome',
        javascriptEnabled: true,
        acceptSslCerts: true,
        chromeOptions: {
          "args": ["--no-sandbox"]
        }
      },
    },

  }
}
