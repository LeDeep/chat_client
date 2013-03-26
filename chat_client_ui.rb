require './ui_helper'

def welcome
  puts "Welcome to the Epicodus chat room. Please keep it clean."
  menu
end

def menu
  choice = nil
  puts "Please enter a screen name for the session: "
  @screen_name = gets.chomp
  puts "#{@screen_name}, welcome. Go ahead and join one of our chats."
  until choice == 'e'
    puts "What would you like to do?"
    puts "Press 'l' to list recent messages, 'p' to post a message."
    puts "Press 'e' to exit."

    case choice = gets.chomp
    when 'l'
      list
    when 'p'
      post
    when 'e'
      exit
    else
      puts "Invalid!"
    end
  end
end

def list
  puts "Here are the recent message in chat: "
  messages = Message.all
  messages.map {|message| puts "User: #{message.screen_name}\nPost: #{message.comment}\nPosted on: #{Time.parse(message.created_at).strftime("%x at: %X")}\n\n"}
end

def post
  puts "Enter the message to post:"
  print "post: "
  comment = gets.chomp
  Message.entry(:screen_name => @screen_name, :comment => comment)
end

welcome