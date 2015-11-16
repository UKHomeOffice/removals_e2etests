And(/^I navigate to the stats page$/) do
  @stats_page = DC_data::Stats_page.new

  visit(@stats_page.url)
  expect(@dashboard_page.dashboard_title.text).to eq (DC_data::Config::Displayed_text::DASHBOARD_PAGE_TITLE)
end


And(/^occupancy has been reset to default$/) do
  displayed_occupancy = @stats_page.occupancy_percentage(@new_post.get_centre_num)
  expect(displayed_occupancy.text).to eq ('0%')
end

When(/^the occupancy percentage is calculated$/) do
  @occupancy = (@new_post.calculate_male_unavailable_beds) + (@new_post.calculate_female_unavailable_beds)
  @capacity = (@dashboard_page.get_male_centre_capacity(@new_post.get_centre_num)) + (@dashboard_page.get_female_centre_capacity(@new_post.get_centre_num))
  @percentage = (@occupancy - @capacity) * 100
end

Then(/^the displayed occupancy percentage is correct$/) do
  displayed_occupancy_percentage = @stats_page.occupancy_percentage(@new_post.get_centre_num)
  expect(displayed_occupancy_percentage.text).to eq ("#{@percentage}"+'%')
end

And(/^the displayed number of (.*) occupied beds is correct$/) do |gender|
  displayed_occupancy = @stats_page.num_occupied_beds(@new_post.get_centre_num,gender)
  expect(displayed_occupancy).to eq (@new_post.get_options[("#{gender}" +'_occupied').to_sym])
end

And(/^the displayed number of (.*) out of commission beds is correct$/) do |gender|
  displayed_ooc_beds = @stats_page.ooc_beds(@new_post.get_centre_num,gender)
  expect(displayed_ooc_beds.text).to eq (@new_post.get_options[("#{gender}" +'_occ').to_sym])
end