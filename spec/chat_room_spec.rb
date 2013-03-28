require 'spec_helper'

describe ChatRoom do 
  let(:screen_name) {'test_user'}
  let(:topic) {'testing'}
  let(:room_id) {1}
  let(:new_chat_room) {ChatRoom.new(:started_by => screen_name, :topic => topic, :id => room_id)}
  let(:created_chat_room) {ChatRoom.create(:started_by => screen_name, :topic => topic)}
  let(:get_id_stub) {stub_request(:get, "#{OUR_URL}/chat_rooms/#{room_id}").
    to_return(:body => "{\"chat_room\":{\"started_by\":\"#{screen_name}\",\"topic\":\"#{topic}\",\"id\":\"#{room_id}\"}}")}
  let(:get_all_stub) {stub_request(:get, "#{OUR_URL}/chat_rooms").
    to_return(:body => "[{\"chat_room\":{\"started_by\":\"#{screen_name}\",\"topic\":\"#{topic}\",\"id\":\"#{room_id}\"}}]")}
  let(:post_stub) {stub_request(:post, "#{OUR_URL}/chat_rooms").
    with(:headers => {'Content-Type' => 'application/json'}, :body => {:chat_room => {:started_by => screen_name, :topic  => topic}}.to_json).
    to_return(:body => "{\"chat_room\":{\"started_by\":\"#{screen_name}\",\"topic\":\"#{topic}\",\"id\":\"#{room_id}\"}}")}
  

  context 'readers' do 
    context '#screen_name' do
      it 'returns the screen_name' do
        new_chat_room.started_by.should eq screen_name
      end
    end

    context '#topic' do
      it 'returns the topic' do
        new_chat_room.topic.should eq topic
      end
    end

    context '#id' do
      it 'returns the id' do
        new_chat_room.id.should eq room_id
      end
    end
  end

  context '.create' do
    it 'POSTs a new chat room' do
      stub = post_stub
      created_chat_room
      stub.should have_been_requested
    end
  end

  context '.get' do 
    it 'GETs a chat room' do 
      stub = get_id_stub
      ChatRoom.get(room_id)
      stub.should have_been_requested
    end

    it 'returns chat room with that id' do 
      get_id_stub
      room = ChatRoom.get(room_id)
      room.should eq new_chat_room
    end
  end


  context '.all' do
    it 'GETs all chat rooms' do
      stub = get_all_stub
      ChatRoom.all
      stub.should have_been_requested
    end

    it 'returns an array of all chat rooms' do
      new_chat_room
      get_all_stub
      ChatRoom.all.first.should be_an_instance_of ChatRoom
    end

  end


end