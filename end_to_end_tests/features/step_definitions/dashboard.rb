When(/^I navigate to the bed management dashboard as a (.*)/) do |user|
  @dashboard_page = DC_data::Dashboard_page.new
  @user = DC_data::Auth_login.new(user)
  @user.login

  visit(@dashboard_page.url)
  expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end

When(/^the number available beds are calculated$/) do
  @available_male_beds = (@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)) - (@new_post.calculate_male_unavailable_beds)
  @available_female_beds = (@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)) - (@new_post.calculate_female_unavailable_beds)
end

Then(/^the number of available beds displayed is correct$/) do
  centre_male_beds = @dashboard_page.disp_male_available_beds(@new_post.get_centre_num)
  centre_female_beds = @dashboard_page.disp_female_available_beds(@new_post.get_centre_num)

  expect(centre_male_beds.text).to eq("#{@available_male_beds}")
  if centre_female_beds == 0
    expect(centre_female_beds).to eq(@available_female_beds)
  else
    expect(centre_female_beds.text).to eq("#{@available_female_beds}")

  end
end

When(/^I navigate to the latest events tab$/) do
  @latest_events_tab=@dashboard_page.latest_events_tab(@new_post.get_centre_num)
  @latest_events_tab.click
#   assert location
end

And(/^I click the stats link$/) do
  @dashboard_page.stats_link.click
  @stats_page = DC_data::Stats_page.new
  expect(@stats_page.stats_title.text).to eq (DC_data::Config::Displayed_text::STATS_PAGE_TITLE)
end

And(/^number available beds have been reset to default$/) do
  disp_available_m_beds = @dashboard_page.disp_male_available_beds(@new_post.get_centre_num)
  disp_available_f_beds = @dashboard_page.disp_female_available_beds(@new_post.get_centre_num)
  expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)}")
  if disp_available_f_beds == 0
    expect(disp_available_f_beds).to eq(@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num))
  else
    expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)}")
  end
end

# And(/^number available female beds has been reset to default$/) do
#   disp_available_beds = @dashboard_page.disp_female_available_beds(@new_post.get_centre_num)
#   expect(disp_available_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)+@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)}"+' available')
# end

And(/^number centre name is displayed correctly on the dashboard page$/) do
  disp_centre_name = @dashboard_page.disp_centre_name(@new_post.get_centre_num)
  expect(disp_centre_name.text).to eq(@new_post.get_options_centre)
end

And(/^number booked beds has been reset to default$/) do
  disp_booked_beds = @dashboard_page.disp_booked_beds(@new_post.get_centre_num)
  expect(disp_booked_beds.text).to eq(DC_data::Config::Displayed_text::DEFAULT_BOOKED)
end

And(/^number reserved beds has been reset to default$/) do
  disp_reserved_beds = @dashboard_page.disp_reserved_beds(@new_post.get_centre_num)
  expect(disp_reserved_beds.text).to eq(DC_data::Config::Displayed_text::DEFAULT_RESERVED)
end

Then(/^partial check (?:in|out) information for the (.*) event is displayed$/) do |id|
  id =define_id(id)

  disp_event_time= @dashboard_page.event_time(@new_post.get_centre_num, id)
  expected_time_disp = @new_post.get_options_timestamp.strftime("%H:%M:%S")
  expect(disp_event_time.text).to eq(expected_time_disp)

  disp_cid_id = @dashboard_page.cid_id(@new_post.get_centre_num, id)
  expected_cid_id_disp = @new_post.get_options_cid_id
  expect(disp_cid_id.text).to eq(expected_cid_id_disp)
end

And(/^there are no events$/) do
  disp_events= @dashboard_page.no_events(@new_post.get_centre_num)
  expect(disp_events).to eq(true)

end


def define_id(id)
  case id
    when 'first'
      1
    when 'second'
      2
    when 'third'
      3
  end
end