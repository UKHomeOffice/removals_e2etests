When(/^I navigate to the bed management dashboard/) do
  @dashboard_page = DC_data::Dashboard_page.new

  visit(@dashboard_page.url)

  expect(@dashboard_page.dashboard_title).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end

Then(/^the number of available beds displayed is correct$/) do
  @new_post.each do |post|
    @available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    @available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)

    centre_male_beds = @dashboard_page.disp_male_available_beds(post.centre_num)
    centre_female_beds = @dashboard_page.disp_female_available_beds(post.centre_num)

    expect(centre_male_beds.text).to eq("#{@available_male_beds}")
    unless centre_female_beds == 0
      expect(centre_female_beds.text).to eq("#{@available_female_beds}")
    end
  end

end

When(/^I navigate to the latest events tab$/) do
  @latest_events_tab=@dashboard_page.latest_events_tab(@new_post.centre_num)
  @latest_events_tab.click
#   assert location
end

And(/^I click the stats link$/) do
  @dashboard_page.stats_link.click
end

And(/^number available beds have been reset to default$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.disp_male_available_beds(post.centre_num)
    disp_available_f_beds = @dashboard_page.disp_female_available_beds(post.centre_num)
    expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")
    unless disp_available_f_beds == 0
      expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
    end
  end

end

And(/^the centre name is displayed correctly on the dashboard page$/) do
  @new_post.each do |post|
    disp_centre_name = @dashboard_page.disp_centre_name(post.centre_num)
    expect(disp_centre_name.text).to eq(post.get_options_centre)
  end

end

# And(/^number booked beds has been reset to default$/) do
#   disp_booked_beds = @dashboard_page.disp_booked_beds(@new_post.centre_num)
#   expect(disp_booked_beds.text).to eq(DC_data::Config::Displayed_text::DEFAULT_BOOKED)
# end
#
# And(/^number reserved beds has been reset to default$/) do
#   disp_reserved_beds = @dashboard_page.disp_reserved_beds(@new_post.centre_num)
#   expect(disp_reserved_beds.text).to eq(DC_data::Config::Displayed_text::DEFAULT_RESERVED)
# end

Then(/^partial check (?:in|out) information for the (.*) event is displayed$/) do |id|
  id =define_id(id)

  disp_event_time= @dashboard_page.event_time(@new_post.centre_num, id)
  expected_time_disp = @new_post.get_options_timestamp.strftime("%H:%M:%S")
  expect(disp_event_time.text).to eq(expected_time_disp)

  disp_cid_id = @dashboard_page.cid_id(@new_post.centre_num, id)
  expected_cid_id_disp = @new_post.get_options_cid_id
  expect(disp_cid_id.text).to eq(expected_cid_id_disp)
end

And(/^there are no events$/) do
  disp_events= @dashboard_page.no_events(@new_post.centre_num)
  expect(disp_events).to eq(true)

end

And(/^occupancy details have been reset to default$/) do
  @new_post.each do |post|
    disp_m_capacity = @dashboard_page.disp_male_capacity(post.centre_num)
    disp_f_capacity = @dashboard_page.disp_female_capacity(post.centre_num)
    disp_m_occupied_beds = @dashboard_page.disp_male_occupied(post.centre_num)
    disp_f_occupied_beds = @dashboard_page.disp_female_occupied(post.centre_num)
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_num)
    disp_f_occ_beds = @dashboard_page.disp_female_occ(post.centre_num)
    disp_available_m_beds = @dashboard_page.disp_male_available_beds(post.centre_num)
    disp_available_f_beds = @dashboard_page.disp_female_available_beds(post.centre_num)

    expect(disp_m_capacity.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")

    expect(disp_m_occupied_beds.text).to eq('0')

    expect(disp_m_occ_beds.text).to eq('0')

    expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")

    unless @dashboard_page.get_female_centre_capacity(post.centre_num) == 0
      expect(disp_f_capacity.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
      expect(disp_f_occupied_beds.text).to eq('0')
      expect(disp_f_occ_beds.text).to eq('0')
      expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
    end
  end
end

And(/^the displayed number of male occupied beds is correct$/) do
  @new_post.each do |post|
    disp_m_occupied_beds = @dashboard_page.disp_male_occupied(post.centre_num)
    expect(disp_m_occupied_beds.text).to eq ("#{post.get_options_male}")
  end
end

And(/^the displayed number of female occupied beds is correct$/) do
  @new_post.each do |post|
    disp_f_occupied_beds = @dashboard_page.disp_female_occupied(post.centre_num)
    unless disp_f_occupied_beds == 0
      expect(disp_f_occupied_beds.text).to eq ("#{post.get_options_female}")
    end
  end
end

And(/^the displayed number of male out of commission beds is correct$/) do
  @new_post.each do |post|
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_num)
    expect(disp_m_occ_beds.text).to eq ("#{post.get_options_ooc_male}")
  end
end

And(/^the displayed number of female out of commission beds is correct$/) do
  @new_post.each do |post|
    disp_f_occ_beds = @dashboard_page.disp_female_occ(post.centre_num)
    unless disp_f_occ_beds == 0
      expect(disp_f_occ_beds.text).to eq ("#{post.get_options_ooc_female}")
    end
  end
end

And(/^the displayed number of male available beds is correct$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.disp_male_available_beds(post.centre_num)
    available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    expect(disp_available_m_beds.text).to eq ("#{available_male_beds}")
  end
end

And(/^the displayed number of female available beds is correct$/) do
  @new_post.each do |post|
    disp_available_f_beds = @dashboard_page.disp_female_available_beds(post.centre_num)
    available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)
    unless disp_available_f_beds == 0
      expect(disp_available_f_beds.text).to eq ("#{available_female_beds}")
    end
  end
end

And(/^number centre name is displayed correctly on the stats page$/) do
  @new_post.each do |post|
    disp_centre_name = @dashboard_page.disp_centre_name(post.centre_num)
    expect(disp_centre_name.text).to eq("#{post.get_options_centre}")
  end
end