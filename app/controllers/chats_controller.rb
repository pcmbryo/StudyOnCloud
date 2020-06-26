class ChatsController < ApplicationController
  def show
    @messages = Chat.where(room_id: params[:id])
  end
end
