require 'spec_helper'

describe Message do
  let(:screen_name) {'test_user'}
  let(:comment) {'testing'}
  let(:room_id) {1}
  let(:new_message) {Message.new(:screen_name => screen_name, :comment => comment, :chat_room_id => room_id)}
  let(:message) {Message.entry(:screen_name => screen_name, :comment => comment, :chat_room_id => room_id)}
  let(:post_stub) {stub_request(:post, "#{OUR_URL}/messages").
    with(:headers => {'Content-Type' => 'application/json'}, :body => {:message => {:screen_name => screen_name, :comment => comment, :chat_room_id => room_id}}.to_json)}
  let(:chat_stub) {stub_request(:get,"#{OUR_URL}/messages" ).
    to_return(:body => "[{\"message\":{\"screen_name\":\"test_user\",\"comment\":\"testing\"}}]")}
  let(:get_feed_stub) {stub_request(:get, "#{OUR_URL}/messages").
    with(:headers => {'Content-Type' => 'application/json'}, :body => {:message => {:chat_room_id => room_id}}.to_json).
    to_return(:body => "[{\"message\":{\"screen_name\":\"#{screen_name}\",\"comment\":\"testing\",\"chat_room_id\":\"#{room_id}\"}}]")}
  let(:chat_room) {ChatRoom.new(:started_by => screen_name, :topic => topic, :id => room_id)}

  context 'readers' do 
    context '#screen_name' do
      it 'returns the screen_name' do
        new_message.screen_name.should eq screen_name
      end
    end
    context '#comment' do
      it 'returns the comment' do
        new_message.comment.should eq comment
      end
    end
    context '#chat_room_id' do
      it 'returns the chat_room_id' do
        new_message.chat_room_id.should eq room_id
      end
    end
  end

  context '.entry' do
    it 'POSTs to the server' do
      stub = post_stub
      message
      stub.should have_been_requested
    end
  end

  context '.all' do 
    it 'GETs all messages for a chat conversation' do 
      stub = chat_stub
      Message.all
      stub.should have_been_requested
    end

    it 'lists all messages for a chat conversation' do 
      stub = chat_stub
      messages = Message.all
      first_message = messages.first
      first_message.should eq new_message
    end
  end

  context '.feed_from' do
    it 'GETs all messages for a chat room' do
      stub = get_feed_stub
      Message.feed_from(room_id)
      stub.should have_been_requested
    end

    it 'returns all messages for a chat room' do
      get_feed_stub
      messages = Message.feed_from(room_id)

      messages.first.should be_an_instance_of Message
    end
  end

end