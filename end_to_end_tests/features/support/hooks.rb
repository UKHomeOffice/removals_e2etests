Before do

  begin
    Capybara.reset_sessions!
  rescue Exception => e
    puts e
  end


  $app_started ||= false
  unless $app_started # do this if app_started does not eql TRUE

    $proxy_port = 9000
    $my_proxy_server = CustomWEBrickProxyServer.new(:Port => $proxy_port)


    trap 'INT' do
      $my_proxy_server.shutdown
    end
    trap 'TERM' do
      $my_proxy_server.shutdown
    end


    $p = fork do
      $my_proxy_server.start
    end


    $port_num = %x(# find a free listening port \n
                  lp=null\n
                  for port in $(seq 4444 4450); do\n
                  lsof -i -n -P |grep LISTEN |grep -q ":${port}"\n
                  [ $? -eq 1 ] && { lp=$port; break; }\n
                  done\n
                  [ "$lp" = "null" ] && { echo "no free local ports available"; return 2; }\n
                  echo $port\n)

    $port_num=$port_num.to_i

    $pid = fork do
      exec "cd\n cd Projects/removals/removals_integration\n PORT=8080 npm run start-with-fixtures"
    end

    system ('sleep 5')

    $pid2 = fork do
      exec "cd\n cd Projects/removals/removals_dashboard\n npm start"
    end

    system ('sleep 5')

    # Separates background apps from tests
    Process.detach($pid)
    Process.detach($p)
    Process.detach($pid2)


  end

  $app_started = true # don't do it again.


  # Checks apps are up and running
  exist?($pid.to_i)
  exist?($p.to_i)
  exist?($pid2.to_i)

  $proxy_address = 'http://'+"#{config('proxy_host')}"+':'+ "#{$proxy_port}"

  create_and_delete_centres


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

end

at_exit do
  begin




    Process.kill(0, $p)
    Process.kill(0, $pid)
    Process.kill(0, $pid2)



    puts "####### Killing background apps #######"
    system("pkill -INT -P'#{$pid}'")
    system ('sleep 5')
    system("pkill -INT -P'#{$p}'")
    system ('sleep 5')
    system("pkill -INT -P'#{$pid2}'")


  rescue Errno::ESRCH
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

def exist?(pid)
  Process.kill(0, pid)
rescue Errno::ESRCH
  puts "####### App failed to start correctly #######"
  exit
end

def create_and_delete_centres
  reset_centres

end

def delete_centres

  # login
  integration_api.get(DC_data::Config::Endpoints::SET_USER_USER, {}, {})


  all_centres_clear = integration_api.get(DC_data::Config::Endpoints::CREATE_CENTRE).body['data']

  if all_centres_clear!= []
    i=1
    while i <=3 do
      integration_api.delete(DC_data::Config::Endpoints::DELETE_CENTRE + "#{i}", {}, {})
      i+=1
    end
    all_centres_clear = integration_api.get(DC_data::Config::Endpoints::CREATE_CENTRE, {}, {}).body['data'].empty?
    expect(all_centres_clear).to eq(true)
  end

end

def create_centres
  i=1
  centres=Array.new
  while i <= 3 do
    centre_name='DC_data::Config::Centre_details::Centre_'+"#{i}"
    centres.push(centre_name.constantize)
    i+=1
  end

  centres.each do |centre|
    @new_centre = DC_data::Centre_post.new(centre)
    @new_centre.create_json(i)
    expect(@new_centre.response.status).to eq(201)

  end

  all_centres_added = integration_api.get(DC_data::Config::Endpoints::CREATE_CENTRE, {}, {}).body['data'].empty?
  expect(all_centres_added).to eq(false)
end


def reset_centres
  integration_api.get(DC_data::Config::Endpoints::SET_USER_USER, {}, {})


  all_centres_clear = integration_api.get(DC_data::Config::Endpoints::CREATE_CENTRE).body['data']

  if all_centres_clear!= []
    i=1
    centres=Array.new
    while i <= 3 do
      centre_name='DC_data::Config::Centre_details::Centre_'+"#{i}"
      centres.push(centre_name.constantize)
      i+=1
    end

    i=1
    centres.each do |centre|
      @new_centre = DC_data::Centre_post.new(centre)
      @new_centre.create_json(i)
      expect(@new_centre.response.status).to eq(200)
      i+=1
    end

  end
end