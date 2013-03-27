class Message

  attr_reader :comment, :screen_name, :created_at, :chat_room_id

  def initialize(attributes)
    @screen_name = attributes[:screen_name]
    @comment = attributes[:comment]
    @created_at = attributes[:created_at]
    @chat_room_id = attributes[:chat_room_id]
  end

  def self.entry(attributes)
    screen_name = attributes[:screen_name]
    comment = attributes[:comment]
    chat_room_id = attributes[:chat_room_id]
    response = Faraday.post do |request|
      request.url "#{OUR_URL}/messages"
      request.headers['Content-Type'] = 'application/json'
      request.body = {:message => {:screen_name => screen_name, :comment => comment, :chat_room_id => chat_room_id}}.to_json
    end
  end

  def self.all
    response = Faraday.get do |request|
      request.url "#{OUR_URL}/messages"
    end
    messages = JSON.parse(response.body, :symbolize_names => true)
    messages.map {|message| Message.new(message[:message])}
  end

  def self.feed_from(room_id)
    response = Faraday.get do |request|
      request.url "#{OUR_URL}/messages"
      request.headers['Content-Type'] = 'application/json'
      request.body = {:message => {:chat_room_id => room_id}}.to_json
    end
    messages = JSON.parse(response.body, :symbolize_names => true)
    messages.map {|message| Message.new(message[:message])}
  end

  def ==(other)
    if other.class != self.class
      false
    else
      self.screen_name == other.screen_name && self.comment == other.comment
    end
  end

end