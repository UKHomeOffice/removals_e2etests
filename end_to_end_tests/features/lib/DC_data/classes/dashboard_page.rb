module DC_data

  class Dashboard_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+"#{"#{config('dashboard_port_num')}"}"
    end

    def dashboard_title
      find(:css, 'body > header > div.banner > h1')
    end

    # def set_centre_data(centre_id)
    #   @displayed_centre_data=find(:css, '#centre-'+"#{centre_id}")
    # end

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

    def disp_centre_name(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > h3')
    end

    def disp_male_available_beds(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.summary > span.availability')
    end

    def disp_female_available_beds(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.summary > span.availability')
    end

    def disp_male_capacity(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.details > table > tbody > tr.capacity > td')
    end

    def disp_female_capacity(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.details > table > tbody > tr.capacity > td')
    end

    def disp_male_occupied(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.details > table > tbody > tr.occupied > td')
    end

    def disp_female_occupied(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.details > table > tbody > tr.occupied > td')
    end

    def disp_male_occ(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.details > table > tbody > tr.outofcommission > td')
    end

    def disp_female_occ(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.details > table > tbody > tr.outofcommission > td')
    end

    def breakdown_male_available_beds(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.details > table > tfoot > tr.availability > td')
    end

    def breakdown_female_available_beds(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.details > table > tfoot > tr.availability > td')
    end

    def expand_button_male(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Male > div.summary > a.detail-toggle')
    end

    def expand_button_female(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > div > div.Female > div.summary > a.detail-toggle')
    end

    def time_stamp(centre_id)
      find(:css, '#centre-'+"#{centre_id}" + ' > span.time')
    end
  end

end

