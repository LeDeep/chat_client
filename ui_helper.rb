require './lib/message'
require './lib/chat_room'
require 'faraday'
require 'json'
require 'time'
require 'timeout'

OUR_URL = "http://localhost:3000"
# OUR_URL = "http://chatty-happy-time.herokuapp.com"