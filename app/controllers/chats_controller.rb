class ChatsController < ApplicationController
  include ApplicationHelper

  before_action :logged_in_user, only: [:show]

  def show
    @page_title = "チャット"
    @messages = Chat.where(room_id: params[:id])
    @room = Room.find(params[:id])
    @no_header_footer = true
  end
end
