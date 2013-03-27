class Message

  attr_reader :comment, :screen_name, :created_at

  def initialize(attributes)
    @screen_name = attributes[:screen_name]
    @comment = attributes[:comment]
    @created_at = attributes[:created_at]
  end

  def self.entry(attributes)
    screen_name = attributes[:screen_name]
    comment = attributes[:comment]
    response = Faraday.post do |request|
      request.url "#{OUR_URL}/messages"
      request.headers['Content-Type'] = 'application/json'
      request.body = {:message => {:screen_name => screen_name, :comment => comment}}.to_json
    end
  end

  def self.all
    response = Faraday.get do |request|
      request.url "#{OUR_URL}/messages"
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