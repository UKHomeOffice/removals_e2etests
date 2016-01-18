module DC_data

  class Env_setup

    include RSpec::Matchers, Capybara::DSL


    attr_reader :port_num

    def initialize(options={})
      @port_num = %x(# find a free listening port \n
                  lp=null\n
                  for port in $(seq 4444 4450); do\n
                  lsof -i -n -P |grep LISTEN |grep -q ":${port}"\n
                  [ $? -eq 1 ] && { lp=$port; break; }\n
                  done\n
                  [ "$lp" = "null" ] && { echo "no free local ports available"; return 2; }\n
                  echo $port\n)
      @port_num=@port_num.to_i
    end


    def reset_centres

      response=internal_api.get(DC_data::Config::Endpoints::CREATE_CENTRE, {}, {'Cookie' => "#{config('keycloak_key')}"})
      expect(response.status).to eq(200)


      unless response['data']==[]

        @delete_centre_ids ||=Array.new
        response.body['data'].each do |centres|
          @delete_centre_ids.push(centres['centre_id'])
        end

        @delete_centre_ids.each do |id|
          response=internal_api.delete(DC_data::Config::Endpoints::DELETE_CENTRE+"/#{id}", {}, {'Cookie' => "#{config('keycloak_key')}"})
          expect(response.status).to eq(200)
        end
      end

      @centres ||=Array.new
      @centre_ids ||=Hash.new
      i=1
      while i <= 3 do
        centre_name='DC_data::Config::Centre_details::Centre_'+"#{i}"
        @centres.push(centre_name.constantize)
        i+=1
      end

      @centres.each do |centre|
        json= centre.to_json
        response=internal_api.post(DC_data::Config::Endpoints::CREATE_CENTRE, json, {'Content-Type' => 'application/json', 'Cookie' => "#{config('keycloak_key')}"})
        @centre_ids[centre[:name]]=response.body['centre_id']
        expect(response.status).to eq(201)
      end


      return @centre_ids

    end

    def create_proxy
      @my_proxy_server= Proxy::CustomWEBrickProxyServer.new(:Port => @port_num)

      trap 'INT' do
        @my_proxy_server.shutdown
      end
      trap 'TERM' do
        @my_proxy_server.shutdown
      end

    end

    def start_proxy
      @pid = fork do
        @my_proxy_server.start
        system ('sleep 5')
        return @pid
      end
    end

    def start_integration_app
      @port_num = 8080
      @pid = fork do
        exec "cd\n cd Projects/removals/removals_integration\n PORT='#{@port_num}' npm run start-with-fixtures"
      end
      system ('sleep 5')
      return @pid
    end

    def start_dashboard_app
      @port_num = 8000
      @pid = fork do
        exec "cd\n cd Projects/removals/removals_dashboard\n npm start"
      end
      system ('sleep 5')
      return @pid
    end


    def exists?
      Process.kill(0, @pid)
    rescue Errno::ESRCH
      puts "####### App failed to start correctly #######"
      exit
    end

    def kill_proxy_app
      exec "kill -INT '#{@pid}'"
      system ('sleep 5')
    rescue Exception => e
      puts e
    end


    def kill_integration_app
      %x(pkill -TERM -P '#{@pid}')
      system ('sleep 5')
    rescue Exception => e
      puts e
    end

    def kill_dashboard_app
      a= %x(lsof -i :"#{@port_num}" -t)
      system("kill -- '#{a.to_i}'")
      system ('sleep 5')
    rescue Exception => e
      puts e
    end

  end
end
