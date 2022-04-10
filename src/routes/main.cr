struct MainRouter
  def initialize
    # Home route
    get "/" do
      layout "home"
    end

    # GET Login(out) routes
    get "/login" do
      layout "login"
    end

    get "/logout" do |env|
      env.redirect "/"
    end

    # POST Login(out) routes
    post "/login" do
      # ....
    end

    # Words route
    get "/words" do
      layout "words"
    end

    get "/allwords" do
      layout "allwords"
    end

    get "/editor" do
      layout "editor"
    end
  end
end
