module DC_data

  class Login_page

    include Capybara::DSL, ShowMeTheCookies

    def login(user)
      @user = user
      case @user
        when 'user'
          page.fill_in 'username', :with => "test"
          page.fill_in 'password', :with => "test"
          click_button('kc-login')
        when 'admin'
          page.fill_in 'username', :with => "#{config('admin_user')}"
          page.fill_in 'password', :with => "#{config('admin_password')}"
          click_button('kc-login')
      end
    end

    def get_cookie

      if $config_file.exclude?('config.yml')

        visit("#{config('integration_host')}:#{config('integration_port_num')}")
        login('admin')

        while config('integration_host') != page.current_host do
          puts "waiting for login to complete"
        end

        ShowMeTheCookies.register_adapter(:chrome, ShowMeTheCookies::SeleniumChrome)
        @keycloak_cookie=get_me_the_cookie(DC_data::Config::Cookie_data::KEYCLOAK_ACCESS)
        $app_config['keycloak_key'] = "#{@keycloak_cookie[:name]}"+'='+"#{@keycloak_cookie[:value]}"
        File.open($config_file, 'w') { |f| f.write $app_config.to_yaml }

      end
    end


  end

end
