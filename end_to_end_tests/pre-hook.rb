#!/usr/bin/env ruby

require 'capybara'
require 'active_support/all'
require 'show_me_the_cookies'
require 'rspec'
require 'yaml'
require 'faraday_middleware'
require './features/lib/DC_data/classes/login_page'
require './features/lib/DC_data/constants/config'
require './features/lib/DC_data/classes/env_setup'




$config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/features/support/config.yml"
$app_config = YAML.load_file($config_file)

def config(key)
  $app_config[key]
end


DC_data::Login_page.new.get_cookie
@created_centre_ids = DC_data::Env_setup.new.reset_centres


File.open("tmp/centre_ids.txt", 'w') do |file|
  file.puts @created_centre_ids
end

puts "Finished"