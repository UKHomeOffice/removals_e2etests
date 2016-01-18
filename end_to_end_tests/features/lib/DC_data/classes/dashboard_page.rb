module DC_data

  class Dashboard_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+"#{$dashboard_port_num}"
     end

    def dashboard_title
      page.title
    end

    def disp_male_available_beds(centre_num)
      case centre_num
        when 1
          find(:css, 'body > div > div > div:nth-child(1) > div.stats-container > div > div > div > div.row.available > div > span')
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(1) > div > div.row.available > div > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(1) > div > div.row.available > div > span')
      end
    end

    def disp_female_available_beds(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(2) > div > div.row.available > div > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(2) > div > div.row.available > div > span')
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

    def disp_centre_name(centre_num)
      case centre_num
        when 1
          find(:css, '#centre-30')
        when 2
          find(:css, '#centre-31')
        when 3
          find(:css, '#centre-32')
      end
    end

    def stats_link
      find(:css, 'body > div > header > a')
    end

    def disp_male_capacity(centre_num)
      case centre_num
        when 1
          find(:css, 'body > div > div > div:nth-child(1) > div.stats-container > div > div > div > div.stats > span.male-capacity > strong > span')
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(1) > div > div.stats > span.male-capacity > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(1) > div > div.stats > span.male-capacity > strong > span')
      end
    end

    def disp_female_capacity(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-capacity > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-capacity > strong > span')
      end
    end

    def disp_male_occupied(centre_num)
      case centre_num
        when 1
          find(:css, 'body > div > div > div:nth-child(1) > div.stats-container > div > div > div > div.stats > span.male-occupied > strong > span')
        when 2
          find(:css, 'body > div > div > div:nth-child(1) > div.stats-container > div > div > div > div.stats > span.male-occupied > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(1) > div > div.stats > span.male-occupied > strong > span')
      end
    end

    def disp_female_occupied(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-occupied > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-occupied > strong > span')
      end
    end

    def disp_male_occ(centre_num)
      case centre_num
        when 1
          find(:css, 'body > div > div > div:nth-child(1) > div.stats-container > div > div > div > div.stats > span.male-ooc > strong > span')
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(1) > div > div.stats > span.male-ooc > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(1) > div > div.stats > span.male-ooc > strong > span')
      end
    end

    def disp_female_occ(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, 'body > div > div > div:nth-child(2) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-ooc > strong > span')
        when 3
          find(:css, 'body > div > div > div:nth-child(3) > div.stats-container > div > div:nth-child(2) > div > div.stats > span.female-ooc > strong > span')
      end
    end

  end
end

