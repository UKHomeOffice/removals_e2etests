module DC_data

  class Auth_login

    def initialize(user)
      @user = user
    end

    def login
      case @user
        when 'user'
          integration_api.get(DC_data::Config::Endpoints::SET_USER_USER, {}, {})
        when 'admin'
          integration_api.get(DC_data::Config::Endpoints::SET_USER_ADMIN, {}, {})
      end

    end


  end

end
