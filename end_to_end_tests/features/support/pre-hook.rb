# #!/usr/bin/env ruby
#
# # require 'capybara/dsl'
# # require 'active_support/all'
# # require 'show_me_the_cookies'
# # require 'rspec/expectations'
# # require 'yaml'
# # require 'faraday_middleware'
#
#
# require './env'
# # require '../lib/DC_data/classes/auth_login'
# # require '../lib/DC_data/constants/config'
# # require '../lib/DC_data/classes/env_setup'
#
#
#
#
# $config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/config.yml"
# $app_config = YAML.load_file($config_file)
#
# def config(key)
#   $app_config[key]
# end
#
#
# DC_data::Auth_login.new.get_cookie
# @created_centre_ids = DC_data::Env_setup.new.reset_centres
#
