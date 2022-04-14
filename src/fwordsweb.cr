require "log"
require "./server"
require "dotenv"

Dotenv.load

Server.new.start
