module DC_data


  class Api_posts


    attr_reader :options, :post, :option_values, :output_keys, :centre_id,:centre_num

    def initialize(centre_id,options={})
      @centre_id = centre_id
      @options = options.symbolize_keys
      @option_values = options.values
      @centre_num = get_centre_num

    end


    def create_heart_beat
      _shellScript = DC_data::Config::Locations::GENERATE_HEART_BEAT

      output = %x(sh #{_shellScript})

      output_array= JSON.parse(output)
      @post= output_array[0]
      @output_keys = @post.keys
      if @options != {}
        i=0
        while i < @output_keys.size
          @post[@output_keys[i]] = @option_values[i]
          i +=1
        end
      end

    end

    def create_basic_event
      _shellScript = DC_data::Config::Locations::GENERATE_EVENT

      output = %x(sh #{_shellScript})

      output_array= JSON.parse(output)
      output_array[0]
      @post= output_array[0]
      if @options != {}
        @options.each_key do |key|
          @post[key] = @options[key]
        end
      end
    end

    def create_inter_site_transfer

    end


    def create_commission_change

    end

    def create_json(api)
      api=case api
            when 'heart beat'
              DC_data::Config::Endpoints::IRC_HEART_BEAT
            when 'events'
              DC_data::Config::Endpoints::IRC_EVENT
          end

      json=@post.to_json
      # puts json
     irc_api.post(api, json, {'Content-Type' => 'application/json'})
    end

    def assign_ooc_reason
      @api_posts_data= @api_posts_data.hashes

      @api_posts_data.each do |hash|

        @api_posts_data_hash=hash.symbolize_keys

        @ooc_reason_hash= Hash.new
        @ooc_reason_hash[:ref]=@api_posts_data_hash[:reference]
        @ooc_reason_hash[:reason]= @api_posts_data_hash[:reason]
        @ooc_reason_hash[:gender]= @api_posts_data_hash[:gender]
        ooc_details_index=@api_posts_data_hash[:ref].to_i-1
        Post_data.get_options[:bed_counts][:out_of_commission][:details][ooc_details_index]=@ooc_reason_hash
      end
    end

    def calculate_male_unavailable_beds
      get_options_male + get_options_ooc_male
    end

    def calculate_female_unavailable_beds
      get_options_female + get_options_ooc_female
    end

    def get_options
      @options
    end

    def get_options_date
      @options[:date]
    end

    def get_options_timestamp
      @options[:timestamp]
    end

    def get_options_centre
      @options[:centre]
    end

    def get_options_operation
      @options[:operation]
    end

    def get_options_cid_id
      @options[:cid_id]
    end

    def get_options_gender
      @options[:gender]
    end

    def get_options_nationality
      @options[:nationality]
    end

    def get_options_male
      @options[:male_occupied]
    end

    def get_options_female
      @options[:female_occupied]
    end

    def get_options_ooc_male
      @options[:male_ooc]
    end

    def get_options_ooc_female
      @options[:female_ooc]
    end

    def get_options_ooc_details
      @options[:details]
    end

    def get_centre_num(centre="#{get_options_centre}")

      case centre
        when 'one'
          1
        when 'two'
          2
        when 'three'
          3
      end
    end

  end

end



