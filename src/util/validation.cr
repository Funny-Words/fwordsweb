module Validation
  def self.validate_username(username : String) : Bool
    raise "Username should contain at least 3 characters" if username.size < 3
    if (username =~ /^[a-zA-Z_][a-zA-Z0-9_\-]*$/).nil?
      raise "Username can only contain alphanumeric characters, " \
            "underscores, and hyphens"
    else
      true
    end
  end

  def self.validate_password(password : String) : Bool
    raise "Password should contain at least 8 characters" if password.size < 8
    if (password =~ /^[[:ascii:]]+$/).nil?
      raise "password should contain only ASCII characters"
    else
      true
    end
  end

  def self.validate_passwords(password : String, password2 : String) : Bool
    if validate_password(password) && validate_password(password2)
      return false if password != password2
    end
    true
  end
end
