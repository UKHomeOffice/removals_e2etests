#!/usr/bin/env ruby

require 'capybara'
require 'active_support/all'
require 'show_me_the_cookies'
require 'rspec'
require 'yaml'
require 'faraday_middleware'
require 'selenium-webdriver'

require_relative '../end_to_end_tests/features/lib/DC_data/classes/login_page'
require_relative '../end_to_end_tests/features/lib/DC_data/constants/config'
require_relative '../end_to_end_tests/features/lib/DC_data/classes/env_setup'




$config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/features/support/config.yml"
$app_config = YAML.load_file($config_file)

def config(key)
  $app_config[key]
end

Capybara.default_driver = :selenium_chrome
Capybara.register_driver :selenium_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.ie("chromeOptions" => {"args" => ["--js-flags=--expose-gc", "--enable-precise-memory-info"]})

  Capybara::Selenium::Driver.new(app, :browser => :chrome, :desired_capabilities => caps)

end

DC_data::Login_page.new.get_cookie
@created_centre_ids = DC_data::Env_setup.new.reset_centres

unless File.exists?(DC_data::Config::Paths::TMP)
  Dir.mkdir(DC_data::Config::Paths::TMP)
end

File.open("tmp/centre_ids.txt", 'w') do |file|
  file.puts @created_centre_ids
end

puts "Finished"