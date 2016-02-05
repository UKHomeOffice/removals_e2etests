When(/^my authentication is (.*)$/) do |outcome|
  case outcome
    when 'successful'
      user='admin'
    when 'unsuccessful'
      user='user'
  end
  DC_data::Login_page.new.login(user)
end

Then(/^I am presented with a log in unsuccessful message$/) do
  expect(page).to have_content DC_data::Config::Displayed_text::UNSUCCESSFUL_LOGIN

end