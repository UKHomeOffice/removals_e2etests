module DC_data


  class Api_posts


    attr_reader :options, :post, :option_values, :output_keys, :response, :header

    def initialize(output_hash, options={})
      @post = output_hash
      @options = options.symbolize_keys
      @option_values = options.values
      @output_keys = output_hash.keys

    end


    def create_heart_beat
      if @options != {}
        i=0
        while i < @output_keys.size
          @post[@output_keys[i]] = @option_values[i]
          i +=1
        end
      end
    end

    def create_basic_event
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

    #
    #
    #   @api_posts_data_hash ||= Hash.new
    #
    #   # tables need to be hashed
    #   if @api_posts_data.class != Array
    #     @api_posts_data= @api_posts_data.hashes
    #   end
    #
    #   @api_posts_data.each do |hash|
    #
    #     @api_posts_data_hash=hash.symbolize_keys
    #
    #
    #     Post_data.define_default_post(@operation.nil? ? @api_posts_data_hash[:operation] : @operation)
    #
    #
    #     Post_data.get_post[:centre]= @centre.nil? ? @api_posts_data_hash[:centre] : @centre
    #     Post_data.get_post[:operation]= @operation.nil? ? @api_posts_data_hash[:operation] : @operation
    #     Post_data.get_post[:bed_counts][:male]=@api_posts_data_hash[:male].to_i
    #     Post_data.get_post[:bed_counts][:female]=@api_posts_data_hash[:female].to_i
    #     Post_data.get_post[:bed_counts][:out_of_commission][:ooc_male]=@api_posts_data_hash[:ooc_male].to_i
    #     Post_data.get_post[:bed_counts][:out_of_commission][:ooc_female]=@api_posts_data_hash[:ooc_female].to_i
    #
    #     Post_data.get_post[:bed_counts][:out_of_commission][:details].clear
    #
    #     y=1
    #     if @api_posts_data_hash[:ooc_male].to_i > 0
    #       x=1
    #       while x <= @api_posts_data_hash[:ooc_male].to_i
    #         ooc = Hash.new
    #         ooc[:ref] = "#{y}"
    #         ooc[:reason] = 'reason' + "#{y}"
    #         ooc[:gender] = 'm'
    #         Post_data.get_post[:bed_counts][:out_of_commission][:details].push(ooc)
    #         x=x+1
    #         y=y+1
    #       end
    #     end
    #
    #     if @api_posts_data_hash[:ooc_female].to_i > 0
    #       x=1
    #       while x <= @api_posts_data_hash[:ooc_female].to_i
    #         ooc = Hash.new
    #         ooc[:ref] = "#{y}"
    #         ooc[:reason] = 'reason' + "#{y}"
    #         ooc[:gender] = 'f'
    #         Post_data.get_post[:bed_counts][:out_of_commission][:details].push(ooc)
    #         x=x+1
    #         y=y+1
    #       end
    #     end
    #
    #
    #     if @upload_type == 'csv'
    #       Post_data.get_post[:cid_id]=@api_posts_data_hash[:cid_id].to_i
    #       Post_data.get_post[:gender]=@api_posts_data_hash[:gender]
    #       Post_data.get_post[:nationality]=@api_posts_data_hash[:nationality]
    #       Post_data.get_post[:date]=@api_posts_data_hash[:date]
    #       Post_data.get_post[:time]=@api_posts_data_hash[:time]
    #       if @api_posts_data_hash[:operation] == 'tra'
    #         Post_data.get_post[:centre_to]=@api_posts_data_hash[:centre_to]
    #       end
    #
    #       create_json
    #
    #     else
    #
    #       Post_data.get_post[:date]= @date.nil? ? Date.today : @date
    #       Post_data.get_post[:time]= @time.nil? ? Time.now.utc.strftime("%H:%M:%S") : @time
    #
    #       if @operation != 'bic' && @operation != 'ooc'
    #         Post_data.get_post[:cid_id]=@api_posts_data_hash[:cid_id].nil? ? Post_data.get_post[:cid_id] : @api_posts_data_hash[:cid_id].to_i
    #         Post_data.get_post[:gender]=@api_posts_data_hash[:gender].nil? ? Post_data.get_post[:gender] : @api_posts_data_hash[:gender]
    #         Post_data.get_post[:nationality]=@api_posts_data_hash[:nationality].nil? ? Post_data.get_post[:nationality] : @api_posts_data_hash[:nationality]
    #       else
    #         Post_data.get_post[:cid_id]=0
    #         Post_data.get_post[:gender]='na'
    #         Post_data.get_post[:nationality]='na'
    #       end
    #
    #       if @operation == 'tra'
    #         Post_data.get_post[:centre_to]=@centre_to
    #       end
    #     end
    #   end
    # end

    def create_json(api)
      json= @post.to_json
      # puts json
      @response = irc_api.post(api, json, {'Content-Type' => 'application/json'})
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


  class Centre_post < Api_posts

    attr_reader :response

    def create_json(i)
      json= @post.to_json
      url = DC_data::Config::Endpoints::AMEND_CENTRE+"#{i}"

      @response = integration_api.post(url, json, {'Content-Type' => 'application/json'})
      # puts @response.body
    end
  end

end



