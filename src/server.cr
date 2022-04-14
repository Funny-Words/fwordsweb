require "moongoon"
require "kemal"
require "kemal-session"
require "http/client"
require "./routes/*"
require "./util/web_macro"
require "./storage"

class Server
  def initialize
    error 404 do
      message = "HTTP 404: Not Found"
      layout "message"
    end

    Log.info { "Initializing routers" }
    APIRouter.new
    MainRouter.new

    Storage::DB.new(ENV["DB_PATH"])

    static_headers do |response|
      response.headers.add("Access-Control-Allow-Origin", "*")
    end

    Kemal::Session.config do |c|
      c.cookie_name = "session_id"
      c.secret = ENV["SECRET"]
      c.timeout = 365.days
      c.gc_interval = 1.day
    end
  end

  def start
    Log.info { "Starting server" }
    Kemal.run
  end
end
