And(/^I navigate to the stats page$/) do
  @stats_page = DC_data::Stats_page.new

  visit(@stats_page.url)
  expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end


And(/^occupancy has been reset to default$/) do
  disp_m_capacity = @stats_page.disp_male_capacity(@new_post.get_centre_num)
  disp_f_capacity = @stats_page.disp_female_capacity(@new_post.get_centre_num)
  disp_m_occupied_beds = @stats_page.disp_male_occupied(@new_post.get_centre_num)
  disp_f_occupied_beds = @stats_page.disp_female_occupied(@new_post.get_centre_num)
  disp_m_occ_beds = @stats_page.disp_male_occ(@new_post.get_centre_num)
  disp_f_occ_beds = @stats_page.disp_female_occ(@new_post.get_centre_num)
  disp_available_m_beds = @stats_page.disp_male_available_beds(@new_post.get_centre_num)
  disp_available_f_beds = @stats_page.disp_female_available_beds(@new_post.get_centre_num)

  expect(disp_m_capacity.text).to eq("#{@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)}")

  expect(disp_m_occupied_beds.text).to eq('0')

  expect(disp_m_occ_beds.text).to eq('0')

  expect(disp_available_m_beds.text).to eq("#{@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)}")

  if @dashboard_page.get_female_centre_capacity(@new_post.get_centre_num) == 0
  else
    expect(disp_f_capacity.text).to eq("#{@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)}")
    expect(disp_f_occupied_beds.text).to eq('0')
    expect(disp_f_occ_beds.text).to eq('0')
    expect(disp_available_f_beds.text).to eq("#{@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)}")
  end
end

And(/^the displayed number of male occupied beds is correct$/) do
  disp_m_occupied_beds = @stats_page.disp_male_occupied(@new_post.get_centre_num)
  expect(disp_m_occupied_beds.text).to eq ("#{@new_post.get_options_male}")
end

And(/^the displayed number of female occupied beds is correct$/) do
  disp_f_occupied_beds = @stats_page.disp_female_occupied(@new_post.get_centre_num)
  if disp_f_occupied_beds == 0
  else
    expect(disp_f_occupied_beds.text).to eq ("#{@new_post.get_options_female}")

  end
end

And(/^the displayed number of male out of commission beds is correct$/) do
  disp_m_occ_beds = @stats_page.disp_male_occ(@new_post.get_centre_num)
  expect(disp_m_occ_beds.text).to eq ("#{@new_post.get_options_ooc_male}")
end

And(/^the displayed number of female out of commission beds is correct$/) do
  disp_f_occ_beds = @stats_page.disp_female_occ(@new_post.get_centre_num)
  if disp_f_occ_beds == 0
  else
    expect(disp_f_occ_beds.text).to eq ("#{@new_post.get_options_ooc_female}")
  end
end

And(/^the displayed number of male available beds is correct$/) do
  disp_available_m_beds = @stats_page.disp_male_available_beds(@new_post.get_centre_num)
  available_male_beds = (@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)) - (@new_post.calculate_male_unavailable_beds)
  expect(disp_available_m_beds.text).to eq ("#{available_male_beds}")
end

And(/^the displayed number of female available beds is correct$/) do
  disp_available_f_beds = @stats_page.disp_female_available_beds(@new_post.get_centre_num)
  available_female_beds = (@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num)) - (@new_post.calculate_female_unavailable_beds)
  if disp_available_f_beds == 0
  else
    expect(disp_available_f_beds.text).to eq ("#{available_female_beds}")
  end
end

And(/^number centre name is displayed correctly on the stats page$/) do
  disp_centre_name = @stats_page.disp_centre_name(@new_post.get_centre_num)
  expect(disp_centre_name.text).to eq("#{@new_post.get_options_centre}")
end