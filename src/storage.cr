require "crypto/bcrypt"

module Storage
  class DB
    @path : String

    def initialize(@path)
      spawn do
        Moongoon.connect("mongodb+srv://#{@path}", "FunnyWords")
      end
      Fiber.yield
    end

    def self.user_is_admin?(username : String) : Bool
    result = true
      begin
        User.find_one!({ username: username, is_admin: true})
      rescue ex
        result = false
      end
      result
    end
  end

  class User < Moongoon::Collection
    collection "users"

    index keys: { username: 1, password: 1 }, options: { unique: true }
    index keys: { is_admin: 1 }, options: { unique: false }

    property username : String
    property password : String
    property is_admin : Bool
  end

  def self.hash_password(pw : String)
    Crypto::Bcrypt::Password.create(pw).to_s
  end

  def self.verify_password(hash, pw : String)
    (Crypto::Bcrypt::Password.new hash).verify pw
  end
end
