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

    # POST Login route
    post "/login" do |env|
    env.response.content_type = "application/json"
      begin
        username = env.params.json["username"].as(String)
        user = Storage::User.find_one({ username: username })

        if user
          password  = env.params.json["password"].as(String)
          stored_pw = user.password

          # Creating token
          if Storage.verify_password(stored_pw, password)
            token = Storage.generate_token({
              "username" => username,
              "user_id" => user._id,
              "is_admin" => user.is_admin,
              "registered_at" => user.registered_at,
              "iat" => Time.utc.to_unix,
              "exp" => Time.utc.to_unix + 86_400
            })

            userobject = Storage::UserStorableObject.new(username, token)
            env.session.object("user", userobject)
          end
        else
          halt env, status_code: 401, response: "Invalid username or password"
        end
      rescue ex
        Log.error { ex }
        halt env, status_code: 500, response: "Internal server error"
      end
      env.redirect "/"
    end

    # Register route
    post "/register" do |env|
    env.response.content_type = "application/json"
      begin
        username  = env.params.json["username"].as(String)
        password  = env.params.json["password"].as(String)
        password2 = env.params.json["password2"].as(String)

        # Validation
        if Validation.validate_username(username) && Validation.validate_passwords(password, password2)
          if !Storage::User.find_one({ username: username })
            hashed_password = Storage.hash_password(password)

            registered_at = Time.utc.to_unix

            user = Storage::User.new(
              username: username,
              password: hashed_password,
              is_admin: false,
              registered_at: registered_at)
            user.insert

            # Creating token
            token = Storage.generate_token({
              "username" => username,
              "user_id" => user._id,
              "is_admin" => user.is_admin,
              "registered_at" => registered_at,
              "iat" => registered_at,
              "exp" => registered_at + 86_400
            })

            userobject = Storage::UserStorableObject.new(username, token)
            env.session.object("user", userobject)
          else
            halt env, status_code: 409, response: "User already exists or passwords do not match"
          end
        else
          halt env, status_code: 400, response: "User already exists or passwords do not match"
        end
      rescue ex
        Log.error { ex }
        halt env, status_code: 500, response: "Internal server error"
      end

      env.response.status_code = 200
      env.redirect "/"
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

    get "/mytoken" do |env|
      begin
      user = env.session.object("user").as(Storage::UserStorableObject)
      env.response.content_type = "application/json"
      {"token": user.token}.to_json
      rescue ex
        halt env, status_code: 401, response: "Unauthorized"
      end
    end
  end
end
