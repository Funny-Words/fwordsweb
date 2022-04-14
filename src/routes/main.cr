require "../util/validation"

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
      env.session.destroy
      env.redirect "/"
    end

    # POST Login(out) routes
    post "/login" do |env|
      message = "Invalid username or password"
      begin
        username = env.params.json["username"].as(String)
        found_user = Storage::User.find_one({ username: username })

        if found_user
          password  = env.params.json["password"].as(String)
          stored_pw = found_user["password"]

          if Storage.verify_password(stored_pw, password)
            message = "Successfully logged in!"
          end
        end
      rescue ex
        Log.error { ex }
      end
    end

    # Register routes
    post "/register" do |env|
      message = "Successfully registered!"
      begin
        username  = env.params.json["username"].as(String)
        password  = env.params.json["password"].as(String)
        password2 = env.params.json["password2"].as(String)

        if Validation.validate_username(username) && Validation.validate_passwords(password, password2)
          if !Storage::User.find_one({ username: username })
            hashed_password = Storage.hash_password(password)
            Storage::User.new(username: username, password: hashed_password, is_admin: false).insert
          else
            message = "Username already exists"
          end
        else
          message = "User already registered or passwords do not match"
        end
      rescue ex
        Log.error { ex }
      end

      {"message": message}.to_json
    end

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
