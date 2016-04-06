When(/^my authentication is unsuccessful$/) do
  if $config_file.exclude?('config.yml')
    user='user'
    DC_data::Login_page.new.login(user)
  end
end

When(/^my authentication is successful$/) do
  if $config_file.exclude?('config.yml')
    user='admin'
    DC_data::Login_page.new.login(user)
    while config('dashboard_host') != page.current_host do
      puts "waiting for login to complete"
    end
  end
end


Then(/^I am presented with a log in unsuccessful message$/) do
  if $config_file.exclude?('config.yml')
    expect(page).to have_content DC_data::Config::Displayed_text::UNSUCCESSFUL_LOGIN
  end
end