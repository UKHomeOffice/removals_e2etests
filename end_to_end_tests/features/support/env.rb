require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/dsl'
require 'faraday_middleware'
require 'date'
require 'active_support/all'
require 'selenium-webdriver'
require 'csv_hasher'
require 'require_all'
require 'time'
require 'browsermob/proxy'

require_all 'features/lib/DC_data/classes'


  proxy = 'localhost:9000'



  Capybara.default_driver = :selenium
  puts "\n ####### RUNNING IN BROWSER #######"
  Capybara.register_driver :selenium do |app|
    profile = Selenium::WebDriver::Firefox::Profile.new
    # profile.proxy = $proxy.selenium_proxy
    profile.proxy = Selenium::WebDriver::Proxy.new(:http => proxy, :ftp => proxy, :ssl => proxy)
    profile['browser.helperApps.alwaysAsk.force'] = false
    profile['browser.cache.disk.enable'] = false
    profile['browser.cache.memory.enable'] = false
    profile['manage.timeouts.implicit_wait'] = 5
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)

  end

# if ENV['IN_BROWSER']
#   # On demand: non-headless tests via Selenium/WebDriver
#   # To run the scenarios in browser (default: Firefox), use the following command line:
#   # IN_BROWSER=true bundle exec cucumber
#   # or (to have a pause of 1 second between each step):
#   # IN_BROWSER=true PAUSE=1 bundle exec cucumber
#
#   # server = BrowserMob::Proxy::Server.new("features/data/browsermob-proxy-2.1.0-beta-3/bin/browsermob-proxy")
#   # server.start
#
#   # $proxy = server.create_proxy
#
#   proxy = 'localhost:9000'
#
#
#
#   Capybara.default_driver = :selenium
#   puts "\n ####### RUNNING IN BROWSER #######"
#   Capybara.register_driver :selenium do |app|
#     profile = Selenium::WebDriver::Firefox::Profile.new
#     # profile.proxy = $proxy.selenium_proxy
#     profile.proxy = Selenium::WebDriver::Proxy.new(:http => proxy, :ftp => proxy, :ssl => proxy)
#     profile['browser.helperApps.alwaysAsk.force'] = false
#     profile['browser.cache.disk.enable'] = false
#     profile['browser.cache.memory.enable'] = false
#     profile['manage.timeouts.implicit_wait'] = 5
#     Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
#
#   end
#
# else
#   # DEFAULT: headless tests with poltergeist/PhantomJS
#   Capybara.register_driver :poltergeist do |app|
#     Capybara::Poltergeist::Driver.new(
#         app,
#         :window_size => [1280, 1024],
#         :phantomjs_options => ['--ignore-ssl-errors=true', '--ssl-protocol=tlsv1'],
#         :js_errors => false,
#         #:debug => true,
#         :timeout => 60
#     )
#   end
#   Capybara.default_driver = :poltergeist
#   Capybara.javascript_driver = :poltergeist
#
#
# end


Capybara.default_selector = :css
Capybara.default_max_wait_time = 5


World(RSpec::Matchers)

config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/config.yml"
$app_config = YAML.load_file(config_file)

def config(key)
  $app_config[key]
end

def integration_api
  @integration_api = Faraday.new(:url => "#{config('integration_host')}"+':8080') do |faraday|
    # faraday.response :logger
    faraday.response :json, :content_type => /\bjson$/
    faraday.use Faraday::Adapter::NetHttp
    faraday.use FaradayMiddleware::ParseJson
    faraday.proxy "#{$proxy_address}"
  end
end

def irc_api
  @integration_api = Faraday.new(:url => "#{config('integration_host')}"+':8080') do |faraday|
    # faraday.response :logger
    faraday.response :json, :content_type => /\bjson$/
    faraday.use Faraday::Adapter::NetHttp
    faraday.use FaradayMiddleware::ParseJson
  end
end