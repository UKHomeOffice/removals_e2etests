module DC_data

  class Stats_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+':8000'+ DC_data::Config::Endpoints::STATS
    end

    def stats_title
      find(:id, 'proposition-name')
    end

    def occupancy_percentage(centre_num)
      case centre_num
        when 1
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when 2
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when 3
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
      end
    end

    def num_occupied_beds(centre_num,gender)
      case [centre_num, gender]
        when [1, 'male']
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [1, 'female']
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2, 'male']
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2,'female']
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3,'male']
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3,'female']
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
      end

    end

    def ooc_beds(centre_num, gender)
      case [centre_num, gender]
        when [1, 'male']
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [1, 'female']
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2, 'male']
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2,'female']
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3,'male']
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3,'female']
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
      end

    end
  end
end
