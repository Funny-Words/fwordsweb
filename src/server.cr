require "kemal"
require "http/client"
require "./routes/*"
require "./util/web_macro"

class Server
  def initialize
    error 404 do
      message = "HTTP 404: Not Found"
      layout "message"
    end

    Log.info { "Initializing routers" }
    APIRouter.new
    MainRouter.new
  end

  def start
    Log.info { "Starting server" }
    Kemal.run
  end
end
