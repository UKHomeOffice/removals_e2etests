module DC_data

  class Auth_login

    def initialize(user)
      @user = user
    end

    def login
      case @user
        when 'user'
        internal_api.get(DC_data::Config::Endpoints::SET_USER_USER, {}, {"#{config('header_type')}" => "#{config('user_email')}"})
        when 'admin'
          internal_api.get(DC_data::Config::Endpoints::SET_USER_ADMIN, {}, {"#{config('header_type')}" => "#{config('user_email')}"})
      end

    end


  end

end
