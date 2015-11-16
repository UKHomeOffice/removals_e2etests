module DC_data

  class Dashboard_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+':8000'+ DC_data::Config::Endpoints::DASHBOARD
    end

    def dashboard_title
      find(:css, '#content_container > h1')
    end

    #
    # def displayed_available_beds(centre_num)
    #   case centre_num
    #     when 1
    #       find(:id, 'tab-beds_1_available')
    #     when 2
    #       find(:id, 'tab-beds_2_available')
    #     when 3
    #       find(:id, 'tab-beds_3_available')
    #   end
    # end


    def displayed_booked_beds(centre_num)
      case centre_num
        when 1
          find(:id, 'tab-beds_1_booked')
        when 2
          find(:id, 'tab-beds_2_booked')
        when 3
          find(:id, 'tab-beds_3_booked')

      end
    end

    def displayed_reserved_beds(centre_num)
      case centre_num
        when 1
          find(:id, 'tab-beds_1_reserved')
        when 2
          find(:id, 'tab-beds_2_reserved')
        when 3
          find(:id, 'tab-beds_3_reserved')
      end
    end

    def displayed_male_available_beds(centre_num)
      case centre_num
        when 1
          find(:css, '#beds_1_available > ul > li > span.bed-count-figure')
        when 2
          find(:css, '#beds_2_available > ul > li:nth-child(1) > span.bed-count-figure')
        when 3
          find(:css, '#beds_3_available > ul > li:nth-child(1) > span.bed-count-figure')
      end
    end

    def displayed_female_available_beds(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, '#beds_2_available > ul > li:nth-child(2) > span.bed-count-figure')
        when 3
          find(:css, '#beds_3_available > ul > li:nth-child(2) > span.bed-count-figure')
      end
    end

    def latest_events_tab(centre_num)
      case centre_num
        when 1
          find(:id, 'tab-beds_1_latest')
        when 2
          find(:id, 'tab-beds_2_latest')
        when 3
          find(:id, 'tab-beds_3_latest')
      end
    end

    def get_male_centre_capacity(centre_num)
      case centre_num
        when 1
          DC_data::Config::Capacities::Male::ONE
        when 2
          DC_data::Config::Capacities::Male::TWO
        when 3
          DC_data::Config::Capacities::Male::THREE
      end
    end

    def get_female_centre_capacity(centre_num)
      case centre_num
        when 1
          DC_data::Config::Capacities::Female::ONE
        when 2
          DC_data::Config::Capacities::Female::TWO
        when 3
          DC_data::Config::Capacities::Female::THREE
      end
    end

    def displayed_centre_name(centre_num)
      case centre_num
        when 1
          find(:css, '#item0 > div > h2')
        when 2
          find(:css, '#item1 > div > h2')
        when 3
          find(:css, '#item2 > div > h2')
      end
    end


    def stats_link
      find(:css, '#proposition-links > li:nth-child(2) > a')
    end

    def event_time(centre_num, id)
      case [centre_num, id]
        when [1, 1]
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [1, 2]
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2, 1]
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [2, 2]
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3, 1]
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when [3, 2]
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
      end
    end


    def person_id(id)
      case id
        when 1
          find(:css, '#beds_1_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when 2
          find(:css, '#beds_2_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
        when 3
          find(:css, '#beds_3_latest-enhanced > table > tbody > tr:nth-child(1) > td:nth-child(1)')
      end
    end


    def no_events(centre_num)
      case centre_num
        when 1
          page.should have_no_selector(:css, '#my-dom-id')
        when 2
          page.should have_no_selector(:css, '#my-dom-id')
        when 3
          page.should have_no_selector(:css, '#my-dom-id')
      end
    end

  end
end

