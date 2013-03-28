require './ui_helper'

def welcome
  puts "\nWelcome to the Epicodus chat room. Please keep it clean."
  main_menu
end

def main_menu
  choice = nil
  puts "\nPlease enter a screen name for the session: "
  @screen_name = gets.chomp
  puts "\nHello, #{@screen_name}!."
  until choice == "\e"
    puts "\nWhat would you like to do?"
    puts "Press 's' start a new chat."
    puts "Press 'j' join a live chat"
    puts "Press [esc] to exit."
    case choice = gets.chomp
    when 's'
      start_chat
    when 'j'
      join
    when "\e"
      exit
    else
      puts "Invalid!"
    end
  end
end

def start_chat
  puts "Please enter a topic for the new chat room: "
  topic = gets.chomp
  puts "You can now post a message to chat room #{topic}."
  new_chat = ChatRoom.create({:started_by => @screen_name, :topic => topic})
  @chat_room = new_chat
  live_chat
end

def join
  ChatRoom.all.each {|room| puts "ID: #{room.id}\nTopic: #{room.topic}\nStarted by: #{room.started_by}\n\n"}
  puts "Please enter the ID of the chat room you would like to join: "
  id_input = gets.chomp
  chosen_room = ChatRoom.get(id_input)
  if chosen_room
    @chat_room = chosen_room
    live_chat
  else
    puts "Error: That chat room wasn't found."
  end
end 

def post(text)
  Message.entry(:screen_name => @screen_name, :comment => text, :chat_room_id => @chat_room.id)
end

def live_chat
  text = nil
  until text == "\e"
    input = nil
    until input
      messages = Message.feed_from(@chat_room.id)
      puts "\e[H\e[2J"
      messages.each {|message| puts display(message)}
      puts "Hit any key to do anything."
      begin
        Timeout.timeout(5) {input = gets.chomp}
      rescue Timeout::Error
      end
    end
    puts "Press [esc] to leave chat."
    print "#{@screen_name}:>> "
    text = gets.chomp
    unless text == "\e"
      post(text)
    else
      puts "\nLeaving the chat...\n"
    end
  end
end

def display(message)
  "\n#{message.screen_name.upcase}:>> '#{message.comment}'\n#{format_time(message.created_at)}\n"
end

def format_time(time_string)
  Time.parse(time_string).localtime.strftime("%x %I:%M %p")
end


welcome
