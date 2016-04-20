const seleniumServer = require('selenium-server')
const chromedriver = require('chromedriver')

const in_docker = process.env.SELENIUM_HOST !== undefined;
const selenium_host = process.env.SELENIUM_HOST || "localhost"

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
      }
    },
    int: {
      launch_url: 'https://wallboard-ircbd-int.notprod.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-ircbd-int.notprod.homeoffice.gov.uk',
      }
    },
    uat: {
      launch_url: 'https://wallboard-ircbd-uat.notprod.homeoffice.gov.uk',
      globals: {
        backend_url: 'https://api-ircbd-uat.notprod.homeoffice.gov.uk',
      }
    },

    default: {
      launch_url: 'http://localhost:8080',
      globals: {
        backend_url: 'http://localhost:8000',
      },
      selenium_port: 4444,
      selenium_host: selenium_host,
      silent: true,
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
