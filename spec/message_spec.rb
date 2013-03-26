require 'spec_helper'

describe Message do
  let(:screen_name) {'test_user'}
  let(:comment) {'testing'}
  let(:new_message) {Message.new(:screen_name => screen_name, :comment => comment)}
  let(:message) {Message.entry(:screen_name => screen_name, :comment => comment)}
  let(:post_stub) {stub_request(:post, "#{OUR_URL}/messages").
    with(:headers => {'Content-Type' => 'application/json'}, :body => {:message => {:screen_name => screen_name, :comment => comment}}.to_json)}
  let(:chat_stub) {stub_request(:get,"#{OUR_URL}/messages" ).
    to_return(:body => "[{\"message\":{\"screen_name\":\"test_user\",\"comment\":\"testing\"}}]")}

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

end