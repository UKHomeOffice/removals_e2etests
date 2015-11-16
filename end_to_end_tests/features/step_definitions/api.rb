When(/^a heart beat is generated with the following information (.*),(.*),(.*),(.*),(.*)$/) do |centre, male, female, ooc_male, ooc_female|
  output_hash = generate_heart_beat_json
  @new_post=DC_data::Api_posts.new(output_hash, {:centre => centre, :male_occupied => male.to_i, :female_occupied => female.to_i, :male_ooc => ooc_male.to_i, :female_ooc => ooc_female.to_i})
  @new_post.create_heart_beat
end

Given(/^a check (?:in|out) has been generated for centre (\D+)$/) do |centre|
  time = Time.now.iso8601
  output_hash = generate_event_json
  @new_post=DC_data::Api_posts.new(output_hash, {:operation => 'check in', :centre => centre, :timestamp => time})
  @new_post.create_basic_event
end

And(/^the information is uploaded to the (\D+) api$/) do |api|
  api=define_api(api)
  @new_post.create_json(api)
end

And(/^the information is successfully uploaded to the (\D+) api$/) do |api|
  api=define_api(api)

  @new_post.create_json(api)
  expect(@new_post.response.status).to eq(200)
end

Then(/^I should receive a 400 error$/) do
  expect(@new_post.response.status).to eq(400)
end

And(/^I should receive errors regarding the failed submission$/) do
  expect(@new_post.response.body).to include('errors')
end


def generate_event_json
  _shellScript = DC_data::Config::Locations::GENERATE_EVENT

  output = %x(sh #{_shellScript})

  output_array= JSON.parse(output)
  output_array[0]
end


def generate_heart_beat_json
  _shellScript = DC_data::Config::Locations::GENERATE_HEART_BEAT

  output = %x(sh #{_shellScript})

  output_array= JSON.parse(output)
  output_array[0]
end

def define_api(api)
  case api
    when 'heart beat'
      DC_data::Config::Endpoints::IRC_HEART_BEAT
    when 'events'
      DC_data::Config::Endpoints::IRC_EVENT
  end
end