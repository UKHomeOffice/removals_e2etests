Before do

  begin
    Capybara.reset_sessions!
  rescue Exception => e
    puts e
  end

  @user = DC_data::Auth_login.new('user')
  @user.login

  @created_centre_ids = DC_data::Env_setup.new.reset_centres
end


AfterStep do
  @performance_info ||= Array.new
  @performance_stats=DC_data::Performance_stats.new
  @performance_stats.collect_garbage
  @performance_info.push(@performance_stats.return_stats)
end


After do |scenario|

  if scenario.failed?
    screenshot_file = "screenshots/#{scenario.name.downcase.tr(" /+<>,.:;|-", "_")[0..64]}.png"
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
    puts "\n ####### SAVING PERFORMANCE INFO #######"
    time = Time.now.iso8601
    File.open("performance_info/#{time}_#{scenario.name.downcase.tr(" /+<>,.:;|-", "_")[0..64]}_performance_info.csv", 'w') do |file|
      file.puts @performance_info
    end
  end

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