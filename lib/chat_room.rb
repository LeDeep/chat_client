class ChatRoom

attr_reader :topic, :started_by, :created_at, :id

  def initialize(attributes)
    @started_by = attributes[:started_by]
    @topic = attributes[:topic]
    @created_at = attributes[:created_at]
    @id = attributes[:id]
  end

  def self.create(attributes)
    started_by = attributes[:started_by]
    topic = attributes[:topic]
    response = Faraday.post do |request|
      request.url "#{OUR_URL}/chat_rooms"
      request.headers['Content-Type'] = 'application/json'
      request.body = {:chat_room => {:started_by => started_by, :topic => topic}}.to_json
    end
    created = JSON.parse(response.body, :symbolize_names => true)
    ChatRoom.new(created[:chat_room])
  end

  def self.all 
    response = Faraday.get do |request|
      request.url "#{OUR_URL}/chat_rooms"
    end
    rooms = JSON.parse(response.body, :symbolize_names => true)
    rooms.map {|room| ChatRoom.new(room[:chat_room])}
  end

  def self.get(id)
    response = Faraday.get do |request|
      request.url "#{OUR_URL}/chat_rooms/#{id}"
      request.headers['Content-Type'] = 'application/json'
    end
    room = JSON.parse(response.body, :symbolize_names => true)
    ChatRoom.new(room[:chat_room])
  end

  def ==(other)
    if other.class != self.class
      false
    else
      self.started_by == other.started_by && self.topic == other.topic
    end
  end

end
