struct MainRouter
  def initialize
    # Home route
    get "/" do
      layout "home"
    end

    # Words route
    get "/words" do
      layout "words"
    end
  end
end
