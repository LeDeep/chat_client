require './ui_helper'

def welcome
  puts "\nWelcome to the Epicodus chat room. Please keep it clean."
  menu
end

def menu
  choice = nil
  puts "\nPlease enter a screen name for the session: "
  @screen_name = gets.chomp
  puts "\nHello, #{@screen_name}!."
  until choice == 'x'
    puts "What would you like to do?"
    puts "Press 'l' for live chat."
    puts "Press 'r' for recent messages list."
    puts "Press 'p' to post a message."
    puts "Press 'x' to exit."
    case choice = gets.chomp
    when 'l'
      live_chat
    when 'r'
      recents_list
    when 'p'
      new_post
    when 'x'
      exit
    else
      puts "Invalid!"
    end
  end
end

def recents_list
  puts "Here are the recent message in chat: "
  messages = Message.all
  messages.map {|message| puts display(message)}-
end

def new_post
  puts "Enter the message to post:"
  print "post: "
  comment = gets.chomp
  Message.entry(:screen_name => @screen_name, :comment => comment)
end

def post(text)
  Message.entry(:screen_name => @screen_name, :comment => text)
end

def live_chat
  puts "Press 'x' to exit and press enter to compose a text"
  text = nil
  until text == 'x'
    time = 0
    input = nil
    until input == ''
      puts "\e[H\e[2J"
      Message.all.each do |message|
        puts display(message)
      end
      begin
        Timeout.timeout(5) {input = gets.chomp}
      rescue Timeout::Error
      end
    end
    print "#{@screen_name}:>> "
    text = gets.chomp
    post(text)
  end
end

def display(message)
  "\n#{message.screen_name.upcase}:>> '#{message.comment}'\n#{format_time(message.created_at)}\n"
end

def format_time(time_string)
  Time.parse(time_string).localtime.strftime("%x %I:%M %p")
end


welcome