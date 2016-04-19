// var seleniumServer = require('selenium-server')
// var phantomjs = require('phantomjs-prebuilt')
// var chromedriver = require('chromedriver')

module.exports = {
  src_folders: [require('nightwatch-cucumber')()],
  output_folder: 'reports',
  custom_commands_path: '',
  custom_assertions_path: '',
  page_objects_path: '',
  live_output: false,
  disable_colors: false,
  // test_workers: {
  //  enabled: true,
  //  workers: 'auto'
  // },

  selenium: {
    start_process: false,
    // server_path: seleniumServer.path,
    log_path: 'reports',
    host: 'selenium',
    port: 4444,
    // cli_args: {
    //   'webdriver.chrome.driver': chromedriver.path
    // }
  },

  test_settings: {
    default: {
      launch_url: 'http://localhost',
      selenium_port: 4444,
      selenium_host: 'selenium',
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
        chromeOptions : {
          "args" : ["--no-sandbox"]
        }
      },
    },

  }
}
