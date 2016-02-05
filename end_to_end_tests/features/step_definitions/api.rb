When(/^a heart beat is generated with the following information centre name (.*),(.*),(.*),(.*),(.*)(?:| taking availability to full| introducing a negative availability)$/) do |centre, male, female, ooc_male, ooc_female|
  @new_post ||=Array.new
  post=DC_data::Api_posts.new(centre_id=@centre_ids[centre], {:centre => centre, :male_occupied => male.to_i, :female_occupied => female.to_i, :male_ooc => ooc_male.to_i, :female_ooc => ooc_female.to_i})
  post.create_heart_beat
  @new_post.push(post)
end

Given(/^a check (?:in|out) has been generated for centre (\D+)$/) do |centre|
  time = Time.now.iso8601
  @new_post ||=Array.new
  @new_post.push(DC_data::Api_posts.new({:operation => 'check in', :centre => centre, :timestamp => time}))
  @new_post.each do |post|
    post.create_basic_event
  end
end

And(/^the information is uploaded to the (\D+) api$/) do |api|
  @new_post.each do |post|
    @response=post.create_json(api)
  end
end

And(/^the information is successfully uploaded to the (\D+) api$/) do |api|
  @new_post.each do |post|
    response=post.create_json(api)
    expect(response.status).to eq(201)
  end

end

Then(/^I should receive a 400 error$/) do
  expect(@response.status).to eq(400)
end

And(/^I should receive errors regarding the failed submission$/) do
  expect(@response.body).to include('errors')
end

Given(/^(\d+) (?:bed|beds) (?:has|have) been put out of commission for centre (.*)$/) do |ooc, centre|
  @new_post =Array.new
  @ooc=ooc.to_i
  post=DC_data::Api_posts.new(centre_id=@centre_ids[centre], {:centre => centre, :male_occupied => 0, :female_occupied => 0, :male_ooc => @ooc, :female_ooc => 0})
  post.create_heart_beat
  @new_post.push(post)
end

Given(/^(\d+) out of commission (?:bed|beds) (?:has|have) been recommissioned for centre (.*)$/) do |recommissioned, centre|
  @new_post =Array.new
  ooc=@ooc-recommissioned.to_i
  post=DC_data::Api_posts.new(centre_id=@centre_ids[centre], {:centre => centre, :male_occupied => 0, :female_occupied => 0, :male_ooc => ooc, :female_ooc => 0})
  post.create_heart_beat
  @new_post.push(post)
end