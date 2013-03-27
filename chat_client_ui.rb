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
    when 'x'
      exit
    else
      puts "Invalid!"
    end
  end
end

def start_chat
  puts "Please enter a topic for the chat room: "
  topic = gets.chomp
  puts "You can now post a message to chat room #{topic}."
  new_chat = ChatRoom.create({:started_by => @screen_name, :topic => topic})
  @chat_room = new_chat
  live_chat
end

def join
  ChatRoom.all.each {|room| puts "ID: #{room.id}\n Topic: #{room.topic}\nStarted by: #{room.started_by}\n\n"}
  puts "Please enter the ID of the chat room you would like to join: "
  id_input = gets.chomp
  @chat_room = ChatRoom.get(id_input)
  live_chat
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


# def chat_menu(chat_room)
#   until choice == "\e"
#     puts "\nWhat would you like to do?"
#     puts "Press 'l' to enter chat."
#     puts "Press 'r' for recent messages list."
#     puts "Press 'p' to post a message."
#     puts "Press [esc] to exit."
#     case choice = gets.chomp
#     when 'l'
#       live_chat
#     when 'r'
#       recents_list
#     when 'p'
#       new_post
#     when 'x'
#       exit
#     else
#       puts "Invalid!"
#     end
#   end
# end

# def recents_list
#   puts "Here are the recent message in chat: "
#   messages = Message.all
#   messages.map {|message| puts display(message)}
# end

# def new_post
#   puts "Enter the message to post:"
#   print "post: "
#   comment = gets.chomp
#   Message.entry(:screen_name => @screen_name, :comment => comment)
# end