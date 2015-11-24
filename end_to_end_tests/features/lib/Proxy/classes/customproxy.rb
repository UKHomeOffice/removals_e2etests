require "webrick"
require "webrick/httpproxy"
require "webrick/httprequest"

class CustomWEBrickProxyServer < WEBrick::HTTPProxyServer
  $user = nil

  def do_GET(req, res)
    perform_proxy_request(req, res) do |http, path, header|
      if path == "/SET_USER/user"
        $user='user'
      elsif path == "/SET_USER/admin"
        $user='admin'
      end
      case $user
        when 'user'
          header["http_email"]="test@example.com"
        when 'admin'
          header["aaa"]="bbb"
      end
      http.get(path, header)
    end
  end

  def do_HEAD(req, res)
    perform_proxy_request(req, res) do |http, path, header|
      if path == "/SET_USER/user"
        $user='user'
      elsif path == "/SET_USER/admin"
        $user='admin'
      end
      case $user
        when
        header["http_email"]="test@example.com"
        when 'admin'
          header["aaa"]="bbb"
      end
      http.head(path, header)
    end
  end


  def do_POST(req, res)
    perform_proxy_request(req, res) do |http, path, header|
      if path == "/SET_USER/user"
        $user='user'
      elsif path == "/SET_USER/admin"
        $user='admin'
      end
      case $user
        when 'user'
          header["http_email"]="test@example.com"
        when 'admin'
          header["aaa"]="bbb"
      end
      http.post(path, req.body || "", header)
    end
  end

  def do_DELETE(req, res)
    perform_proxy_request(req, res) do |http, path, header|
      if path == "/SET_USER/user"
        $user='user'
      elsif path == "/SET_USER/admin"
        $user='admin'
      end
      case $user
        when 'user'
          header["http_email"]="test@example.com"
        when 'admin'
          header["aaa"]="bbb"
      end
      http.delete(path, header)
    end
  end

end

