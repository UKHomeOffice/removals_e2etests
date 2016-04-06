When(/^my authentication is unsuccessful$/) do
  user='user'
  DC_data::Login_page.new.login(user)
end

When(/^my authentication is successful$/) do
  user='admin'
  DC_data::Login_page.new.login(user)
  while config('dashboard_host') != page.current_host do
    puts "waiting for login to complete"
  end
end


Then(/^I am presented with a log in unsuccessful message$/) do
  expect(page).to have_content DC_data::Config::Displayed_text::UNSUCCESSFUL_LOGIN

end