class ChatsController < ApplicationController
  include ApplicationHelper

  before_action :logged_in_user, only: [:show]

  def show
    @messages = Chat.where(room_id: params[:id])
  end
end
