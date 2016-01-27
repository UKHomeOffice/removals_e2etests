module DC_data
  module Config

    module Endpoints
      DASHBOARD = '/#availability'
      STATS = '/#statistics'
      IRC_HEART_BEAT = '/irc_entry/heartbeat'
      IRC_EVENT = '/irc_entry/event'
      CREATE_CENTRE = '/centres'
      DELETE_CENTRE = '/centres'
      AMEND_CENTRE =  '/centres'
      SET_USER_USER = '/SET_USER/user'
      SET_USER_ADMIN = '/SET_USER/admin'


    end

    module Locations
      TOTALS_CSV = 'features/data/totals.csv'
      GENERATE_HEART_BEAT ='features/data/generate_heart_beat.sh'
      GENERATE_EVENT ='features/data/generate_event.sh'
      TEST = 'features/data/start_int_port.sh'
    end

    module Capacities
      module Male
        ONE= 150
        TWO = 100
        THREE = 50
      end
      module Female
        ONE= 0
        TWO = 100
        THREE = 50
      end
    end

    module Centre_details
      Centre_1 = {
          :name => 'one',
          :male_capacity => DC_data::Config::Capacities::Male::ONE,
          :female_capacity => DC_data::Config::Capacities::Female::ONE,
      }
      Centre_2 = {
          :name => 'two',
          :male_capacity => DC_data::Config::Capacities::Male::TWO,
          :female_capacity => DC_data::Config::Capacities::Female::TWO,
      }
      Centre_3 = {
          :name => 'three',
          :male_capacity => DC_data::Config::Capacities::Male::THREE,
          :female_capacity => DC_data::Config::Capacities::Female::THREE,
      }

    end

    module Displayed_text
      DASHBOARD_PAGE_TITLE = 'IRC Bed Management'
      STATS_PAGE_TITLE = 'IRC bed stats'
      DEFAULT_BOOKED = '0 booked'
      DEFAULT_RESERVED = '0 ring-fenced'
    end

    module Cookie_data
      KEYCLOAK_ACCESS = 'kc-access'
    end

  end

end
