Before do

  begin
    Capybara.reset_sessions!
  rescue Exception => e
    puts e
  end

  $performance_info ||= Array.new

  $app_started ||= false
  unless $app_started # do this if app_started does not eql TRUE


    $proxy_server=DC_data::Hooks_setup.new
    $proxy_server.create_proxy
    @proxy_pid = $proxy_server.start_proxy
    Process.detach(@proxy_pid)

    $backend_app=DC_data::Hooks_setup.new
    @backend_pid=$backend_app.start_backend_app
    Process.detach(@backend_pid)

    $frontend_app=DC_data::Hooks_setup.new
    @frontend_pid=$frontend_app.start_frontend_app
    Process.detach(@frontend_pid)

    $proxy_server.exists?
    $backend_app.exists?
    $frontend_app.exists?

  end

  $app_started = true # don't do it again.

  $proxy_address = 'http://'+"#{config('proxy_host')}"+':'+ "#{$proxy_server.port_num}"

  @user = DC_data::Auth_login.new('user')
  @user.login

  DC_data::Hooks_setup.new.create_centres

end


After do |scenario|

  if scenario.failed?
    screenshot_file = "screenshot/#{scenario.name.downcase.tr(" /+<>,.:;|-", "_")[0..64]}.png"
    save_screenshot("#{screenshot_file}")
    puts "\n Saving screenshot for a failed scenario here" + " " + (File.expand_path(screenshot_file))
    puts "The failing feature can be found here" + " " + scenario.location + "\n"
  end

  begin
    wait_for_ajax
    page.driver.reset!
  rescue Exception => e
    puts e
  end

  begin
    time = Time.now.iso8601
    File.open("performance_info/#{time}_#{scenario.name.downcase.tr(" /+<>,.:;|-", "_")[0..64]}_performance_info.csv", 'w') do |file|
      file.puts $performance_info
    end
  end

end

at_exit do
  puts "####### Killing frontend app #######"
  $frontend_app.kill_frontend_app
  puts "####### Killing background app #######"
  $backend_app.kill_backend_app
  puts "####### Killing proxy apps #######"
  $proxy_server.kill_proxy_app
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    loop until finished_all_ajax_requests?
  end
end

def finished_all_ajax_requests?
  begin
    page.evaluate_script("(typeof jQuery !== \"undefined\") ? jQuery.active : 0").zero?
  rescue Exception => e
    puts e
  end
end