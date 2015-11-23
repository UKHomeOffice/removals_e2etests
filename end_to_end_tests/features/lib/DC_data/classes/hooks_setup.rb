module DC_data
  class Hooks_setup

    include RSpec::Matchers

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

    def create_centres

      @centres ||=Array.new
      i=1
      while i <= 3 do
        centre_name='DC_data::Config::Centre_details::Centre_'+"#{i}"
        @centres.push(centre_name.constantize)
        i+=1
      end
      i=1
      @centres.each do |centre|
        json= centre.to_json
        url = DC_data::Config::Endpoints::AMEND_CENTRE+"#{i}"

        response=integration_api.post(url, json, {'Content-Type' => 'application/json'})
        expect(response.status).to eq(200)
        i+=1

      end
    end

    def create_proxy
      @port_num = 9000
      @my_proxy_server= CustomWEBrickProxyServer.new(:Port => @port_num)

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

    def start_backend_app
      @port_num = 8080
      @pid = fork do
        exec "cd\n cd Projects/removals/removals_integration\n PORT='#{@port_num}' npm run start-with-fixtures"
      end
      system ('sleep 5')
      return @pid
    end

    def start_frontend_app
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
    end

    def kill_backend_app
      %x(pkill -TERM -P '#{@pid}')
      system ('sleep 5')
    end

    def kill_frontend_app
      a= %x(lsof -i :8000 -t)
      system("kill -- '#{a.to_i}'")
      system ('sleep 5')
    end

  end
end
