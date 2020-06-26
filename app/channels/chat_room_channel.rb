class ChatRoomChannel < ApplicationCable::Channel
  include ApplicationHelper

  def subscribed
    stream_from "chat_room_channel_#{params['room']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Chat.create!(text: data['message'], user_id: current_client_user.id, room_id: params['room'] )
  end
end
