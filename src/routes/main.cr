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

    get "/allwords" do
      layout "all_words"
    end

    get "/editor" do
      layout "editor"
    end
  end
end
