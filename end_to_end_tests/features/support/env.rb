require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/dsl'
require 'faraday_middleware'
require 'date'
require 'active_support/all'
require 'selenium-webdriver'
require 'require_all'
require 'time'
require 'csv'

require_all 'features/lib/DC_data/classes'
require_all 'features/lib/Proxy/classes'


config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/config.yml"
$app_config = YAML.load_file(config_file)

def config(key)
  $app_config[key]
end


$app_started ||= false
unless $app_started # do this if app_started does not eql TRUE

  if ENV['PROXY']
    puts "\n ####### RUNNING PROXY #######"

    @proxy_server=DC_data::Env_setup.new
    @proxy_server.create_proxy
    @proxy_pid = @proxy_server.start_proxy
    Process.detach(@proxy_pid)
    @proxy_server.exists?


    $proxy_address = 'http://'+"#{config('proxy_host')}"+":#{@proxy_server.port_num}"


    PROXY = "#{config('proxy_host')}"+":#{@proxy_server.port_num}"


    proxy = Selenium::WebDriver::Proxy.new(
        :http => PROXY,
        :ftp => PROXY,
        :ssl => PROXY
    )

    at_exit do
      puts "\n ####### Killing proxy apps #######"
      @proxy_server.kill_proxy_app
    end
  else
    proxy = nil
    $proxy_address = nil
  end

  if ENV['INTEGRATION_APP']
    puts "\n ####### RUNNING INTEGRATION APP #######"


    @integration_app=DC_data::Env_setup.new
    @integration_pid=@integration_app.start_integration_app
    Process.detach(@integration_pid)
    @integration_app.exists?


    $integration_port_num=@integration_app.port_num

    at_exit do
      puts "####### Killing integration app #######"
      @integration_app.kill_integration_app
    end

  else
    $integration_port_num="#{config('integration_port_num')}"

  end


  if ENV['DASHBOARD_APP']
    puts "\n ####### RUNNING DASHBOARD APP #######"

    @dashboard_app=DC_data::Env_setup.new
    @dashboard_pid=@dashboard_app.start_dashboard_app
    Process.detach(@dashboard_pid)
    @dashboard_app.exists?

    $dashboard_port_num=@dashboard_app.port_num

    at_exit do
      puts "####### Killing dashboard app #######"
      @dashboard_app.kill_dashboard_app
    end


  else

    $dashboard_port_num="#{config('dashboard_port_num')}"

  end


  puts "\n ####### RUNNING IN BROWSER #######"

  Capybara.default_driver = :chrome
  Capybara.register_driver :chrome do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.ie(:proxy => proxy, "chromeOptions" => {"args" => ["--js-flags=--expose-gc", "--enable-precise-memory-info"]})

    Capybara::Selenium::Driver.new(app, :browser => :chrome, :desired_capabilities => caps)

  end

end

$app_started = true # don't do it again.


Capybara.default_selector = :css
Capybara.default_max_wait_time = 5


def internal_api
  @integration_api = Faraday.new(:url => "#{config('integration_host')}"+":#{$integration_port_num}") do |faraday|
    # faraday.response :logger
    faraday.response :json, :content_type => /\bjson$/
    faraday.use Faraday::Adapter::NetHttp
    faraday.use FaradayMiddleware::ParseJson
    faraday.proxy "#{$proxy_address}"

  end
end

def irc_api
  @integration_api = Faraday.new(:url => "#{config('integration_host')}"+":#{$integration_port_num}") do |faraday|
    # faraday.response :logger
    faraday.response :json, :content_type => /\bjson$/
    faraday.use Faraday::Adapter::NetHttp
    faraday.use FaradayMiddleware::ParseJson
  end
end
