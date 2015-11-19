module DC_data

  class Stats_page

    include Capybara::DSL

    attr_reader :url

    def initialize
      @url = "#{config('dashboard_host')}"+':8000'+ DC_data::Config::Endpoints::STATS
    end

    def stats_title
      find(:css, '#content_container > h1')
    end

    def disp_male_capacity(centre_num)
      case centre_num
        when 1
          find(:css, '#stat0 > div > table > tbody > tr.row_centre_capacity > td:nth-child(2)')
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_capacity > td:nth-child(2)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_capacity > td:nth-child(2)')
      end
    end

    def disp_female_capacity(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_capacity > td:nth-child(3)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_capacity > td:nth-child(3)')
      end
    end

    def disp_male_occupied(centre_num)
      case centre_num
        when 1
          find(:css, '#stat0 > div > table > tbody > tr.row_centre_occupied > td:nth-child(2)')
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_occupied > td:nth-child(2)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_occupied > td:nth-child(2)')
      end
    end

    def disp_female_occupied(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_occupied > td:nth-child(3)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_occupied > td:nth-child(3)')
      end
    end

    def disp_male_occ(centre_num)
      case centre_num
        when 1
          find(:css, '#stat0 > div > table > tbody > tr.row_centre_ooc > td:nth-child(2)')
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_ooc > td:nth-child(2)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_ooc > td:nth-child(2)')
      end
    end

    def disp_female_occ(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_ooc > td:nth-child(3)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_ooc > td:nth-child(3)')
      end
    end

    def disp_male_available_beds(centre_num)
      case centre_num
        when 1
          find(:css, '#stat0 > div > table > tbody > tr.row_centre_availability > td:nth-child(2)')
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_availability > td:nth-child(2)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_availability > td:nth-child(2)')
      end
    end

    def disp_female_available_beds(centre_num)
      case centre_num
        when 1
          0
        when 2
          find(:css, '#stat1 > div > table > tbody > tr.row_centre_availability > td:nth-child(3)')
        when 3
          find(:css, '#stat2 > div > table > tbody > tr.row_centre_availability > td:nth-child(3)')
      end
    end

    def disp_centre_name(centre_num)
      case centre_num
        when 1
          find(:css, '#stat0 > div > table > thead > tr > th.centre_name')
        when 2
          find(:css, '#stat1 > div > table > thead > tr > th.centre_name')
        when 3
          find(:css, '#stat2 > div > table > thead > tr > th.centre_name')
      end
    end

  end
end

