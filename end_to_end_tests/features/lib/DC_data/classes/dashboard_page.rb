module DC_data

  class Dashboard_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+"#{$dashboard_port_num}"
    end

    def dashboard_title
      find(:css, 'body > header > div.banner > h1')
    end

    def disp_male_available_beds(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(1) > span.header-row-one')
        when 2
          find(:css, '#ember450 > div > div:nth-child(5) > span.header-row-one')
        when 3
          find(:css, '#ember450 > div > div:nth-child(9) > span.header-row-one')
      end
    end

    def disp_female_available_beds(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(7) > span.header-row-one')
        when 3
          find(:css, '#ember450 > div > div:nth-child(11) > span.header-row-one')
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
          find(:css, '#ember450 > div > div:nth-child(1) > span.header-row-zero > span.title')
        when 2
          find(:css, '#ember450 > div > div:nth-child(5) > span.header-row-zero > span.title')
        when 3
          find(:css, '#ember450 > div > div:nth-child(9) > span.header-row-zero > span.title')
      end
    end

    def stats_link
      find(:css, 'body > div > header > a')
    end

    def disp_male_capacity(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(2) > span:nth-child(2) > span.right')
        when 2
          find(:css, '#ember450 > div > div:nth-child(6) > span:nth-child(2) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(10) > span:nth-child(2) > span.right')
      end
    end

    def disp_female_capacity(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(8) > span:nth-child(2) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(12) > span:nth-child(2) > span.right')
      end
    end

    def disp_male_occupied(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(2) > span:nth-child(3) > span.right')
        when 2
          find(:css, '#ember450 > div > div:nth-child(6) > span:nth-child(3) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(10) > span:nth-child(3) > span.right')
      end
    end

    def disp_female_occupied(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(8) > span:nth-child(3) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(12) > span:nth-child(3) > span.right')
      end
    end

    def disp_male_occ(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(2) > span:nth-child(4) > span.right')
        when 2
          find(:css, '#ember450 > div > div:nth-child(6) > span:nth-child(4) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(10) > span:nth-child(4) > span.right')
      end
    end

    def disp_female_occ(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(8) > span:nth-child(4) > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(12) > span:nth-child(4) > span.right')
      end
    end

    def breakdown_male_available_beds(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(2) > span.table-row.availability > span.right')
        when 2
          find(:css, '#ember450 > div > div:nth-child(6) > span.table-row.availability > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(10) > span.table-row.availability > span.right')
      end
    end

    def breakdown_female_available_beds(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(8) > span.table-row.availability > span.right')
        when 3
          find(:css, '#ember450 > div > div:nth-child(12) > span.table-row.availability > span.right')
      end
    end

    def expand_button_male(centre_num)
      case centre_num
        when 1
          find(:css, '#ember450 > div > div:nth-child(1) > span.header-row-two > span.right > a')
        when 2
          find(:css, '#ember450 > div > div:nth-child(5) > span.header-row-two > span.right > a')
        when 3
          find(:css, '#ember450 > div > div:nth-child(9) > span.header-row-two > span.right > a')
      end
    end

    def expand_button_female(centre_num)
      case centre_num
        when 1
          nil
        when 2
          find(:css, '#ember450 > div > div:nth-child(7) > span.header-row-two > span.right > a')
        when 3
          find(:css, '#ember450 > div > div:nth-child(11) > span.header-row-two > span.right > a')
      end
    end
  end

end

