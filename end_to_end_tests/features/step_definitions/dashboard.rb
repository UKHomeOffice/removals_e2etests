When(/^I navigate to the bed management dashboard/) do
  @dashboard_page = DC_data::Dashboard_page.new

  visit(@dashboard_page.url)

  expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)

  # @new_post.each do |post|
  #   @dashboard_page.set_centre_data(post.centre_id)
  # end
end

Then(/^the number of available beds displayed is correct$/) do
  @new_post.each do |post|
    available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    centre_male_beds = @dashboard_page.disp_male_available_beds(post.centre_id)
    expect(centre_male_beds.text).to eq("#{available_male_beds}")

    unless post.centre_num == 1
      available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)
      centre_female_beds = @dashboard_page.disp_female_available_beds(post.centre_id)
      expect(centre_female_beds.text).to eq("#{available_female_beds}")
    end
  end
end

Then(/^the number of available beds displayed is a negative value$/) do
  @new_post.each do |post|
    available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    centre_male_beds = @dashboard_page.disp_male_available_beds(post.centre_id)
    expect(centre_male_beds.text).to eq("#{available_male_beds}")
    expect(available_male_beds).to be <(0)

    unless post.centre_num == 1
      available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)
      centre_female_beds = @dashboard_page.disp_female_available_beds(post.centre_id)
      expect(centre_female_beds.text).to eq("#{available_female_beds}")
      expect(available_female_beds).to be <(0)
    end
  end
end

Then(/^the number of available beds displayed states FULL$/) do
  @new_post.each do |post|
    centre_male_beds = @dashboard_page.disp_male_available_beds(post.centre_id)
    expect(centre_male_beds.text).to eq(DC_data::Config::Displayed_text::FULL_CAPACITY)

    unless post.centre_num == 1
      centre_female_beds = @dashboard_page.disp_female_available_beds(post.centre_id)
      expect(centre_female_beds.text).to eq(DC_data::Config::Displayed_text::FULL_CAPACITY)
    end
  end

end

And(/^number available beds have been reset to default$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.disp_male_available_beds(post.centre_id)
    expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")
    unless post.centre_num ==1
      disp_available_f_beds = @dashboard_page.disp_female_available_beds(post.centre_id)
      expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
    end
  end

end

And(/^the centre name is displayed correctly on the dashboard page$/) do
  @new_post.each do |post|
    disp_centre_name = @dashboard_page.disp_centre_name(post.centre_id)
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
#
# Then(/^partial check (?:in|out) information for the (.*) event is displayed$/) do |id|
#   id =define_id(id)
#
#   disp_event_time= @dashboard_page.event_time(@new_post.centre_num, id)
#   expected_time_disp = @new_post.get_options_timestamp.strftime("%H:%M:%S")
#   expect(disp_event_time.text).to eq(expected_time_disp)
#
#   disp_cid_id = @dashboard_page.cid_id(@new_post.centre_num, id)
#   expected_cid_id_disp = @new_post.get_options_cid_id
#   expect(disp_cid_id.text).to eq(expected_cid_id_disp)
# end
#
# And(/^there are no events$/) do
#   disp_events= @dashboard_page.no_events(@new_post.centre_num)
#   expect(disp_events).to eq(true)
# end

And(/^occupancy details have been reset to default$/) do
  @new_post.each do |post|
    disp_m_capacity = @dashboard_page.disp_male_capacity(post.centre_id)
    disp_m_occupied_beds = @dashboard_page.disp_male_occupied(post.centre_id)
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_id)
    disp_available_m_beds = @dashboard_page.breakdown_male_available_beds(post.centre_id)
    expect(disp_m_capacity.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")
    expect(disp_m_occupied_beds.text).to eq('0')
    expect(disp_m_occ_beds.text).to eq('0')
    expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(post.centre_num)}")

    unless post.centre_num == 1
      disp_f_capacity = @dashboard_page.disp_female_capacity(post.centre_id)
      disp_f_occupied_beds = @dashboard_page.disp_female_occupied(post.centre_id)
      disp_f_occ_beds = @dashboard_page.disp_female_occ(post.centre_id)
      disp_available_f_beds = @dashboard_page.breakdown_female_available_beds(post.centre_id)
      expect(disp_f_capacity.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
      expect(disp_f_occupied_beds.text).to eq('0')
      expect(disp_f_occ_beds.text).to eq('0')
      expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(post.centre_num)}")
    end
  end
end

And(/^the displayed number of male occupied beds is correct$/) do
  @new_post.each do |post|
    disp_m_occupied_beds = @dashboard_page.disp_male_occupied(post.centre_id)
    expect(disp_m_occupied_beds.text).to eq ("#{post.get_options_male}")
  end
end

And(/^the displayed number of female occupied beds is correct$/) do
  @new_post.each do |post|
    unless post.centre_num == 1
      disp_f_occupied_beds = @dashboard_page.disp_female_occupied(post.centre_id)
      expect(disp_f_occupied_beds.text).to eq ("#{post.get_options_female}")
    end
  end
end

And(/^the displayed number of male out of commission beds is correct$/) do
  @new_post.each do |post|
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_id)
    expect(disp_m_occ_beds.text).to eq ("#{post.get_options_ooc_male}")
  end
end

And(/^the displayed number of female out of commission beds is correct$/) do
  @new_post.each do |post|
    unless post.centre_num == 1
      disp_f_occ_beds = @dashboard_page.disp_female_occ(post.centre_id)
      expect(disp_f_occ_beds.text).to eq ("#{post.get_options_ooc_female}")
    end
  end
end

And(/^the displayed number of male available beds within the breakdown is correct$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.breakdown_male_available_beds(post.centre_id)
    available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    expect(disp_available_m_beds.text).to eq ("#{available_male_beds}")
  end
end

And(/^the displayed number of male available beds within the breakdown states FULL$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.breakdown_male_available_beds(post.centre_id)
    expect(disp_available_m_beds.text).to eq (DC_data::Config::Displayed_text::FULL_CAPACITY)
  end
end

And(/^the displayed number of male available beds within the breakdown is a negative value$/) do
  @new_post.each do |post|
    disp_available_m_beds = @dashboard_page.breakdown_male_available_beds(post.centre_id)
    available_male_beds = (@dashboard_page.get_male_centre_capacity(post.centre_num)) - (post.calculate_male_unavailable_beds)
    expect(disp_available_m_beds.text).to eq ("#{available_male_beds}")
    expect(available_male_beds).to be <(0)
  end
end


And(/^the displayed number of female available beds within the breakdown is correct$/) do
  @new_post.each do |post|
    unless post.centre_num == 1
      disp_available_f_beds = @dashboard_page.breakdown_female_available_beds(post.centre_id)
      available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)
      expect(disp_available_f_beds.text).to eq ("#{available_female_beds}")
    end
  end
end


And(/^the displayed number of female available beds within the breakdown states FULL$/) do
  @new_post.each do |post|
    disp_available_f_beds = @dashboard_page.breakdown_female_available_beds(post.centre_id)
    expect(disp_available_f_beds.text).to eq (DC_data::Config::Displayed_text::FULL_CAPACITY)
  end
end
And(/^the displayed number of female available beds within the breakdown is a negative value$/) do
  @new_post.each do |post|
    disp_available_f_beds = @dashboard_page.breakdown_female_available_beds(post.centre_id)
    available_female_beds = (@dashboard_page.get_female_centre_capacity(post.centre_num)) - (post.calculate_female_unavailable_beds)
    expect(disp_available_f_beds.text).to eq ("#{available_female_beds}")
    expect(available_female_beds).to be <(0)
  end
end

Then(/^the dashboard should display the updated out of commission beds number on the dashboard$/) do
  @new_post.each do |post|
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_id)
    expect(disp_m_occ_beds.text).to eq ("#{post.get_options_ooc_male}")
  end
end

And(/^I expand to see further data$/) do
  @new_post.each do |post|
    expand_button_male = @dashboard_page.expand_button_male(post.centre_id)
    expand_button_male.click
    unless post.centre_num == 1
      expand_button_female = @dashboard_page.expand_button_female(post.centre_id)
      expand_button_female.click
    end
  end
end

Given(/^I attempt to log into the Bed Dashboard$/) do
  Capybara.current_session.driver.quit

  @dashboard_page = DC_data::Dashboard_page.new

  visit(@dashboard_page.url)
end

And(/^I am not able to access the Bed Dashboard tool$/) do
  !expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end

Then(/^I am directed to the Bed Dashboard web page$/) do
  expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end

And(/^I condense to see only the available beds$/) do
  @new_post.each do |post|
    condense_button_male = @dashboard_page.expand_button_male(post.centre_id)
    condense_button_male.click
    expect { @dashboard_page.disp_male_occupied(post.centre_id) }.to raise_error
    unless post.centre_num == 1
      condense_button_female = @dashboard_page.expand_button_female(post.centre_id)
      condense_button_female.click
      expect { @dashboard_page.disp_female_occupied(post.centre_id) }.to raise_error
    end
  end
end

Then(/^the dashboard should display (\d+) out of commission beds number on the dashboard$/) do |ooc|
  @new_post.each do |post|
    disp_m_occ_beds = @dashboard_page.disp_male_occ(post.centre_id)
    expect(disp_m_occ_beds.text).to eq (ooc)
  end
end


And(/^I can when the data was last updated$/) do
  @new_post.each do |post|
    time_submitted = @dashboard_page.time_stamp(post.centre_id)
    time_submitted= Time.parse(time_submitted.text.split(" ").last)
    time_diff = (Time.now - time_submitted)
    expect(time_diff).to be < 30
  end
end
