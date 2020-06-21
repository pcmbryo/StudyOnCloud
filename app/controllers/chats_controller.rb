class ChatsController < ApplicationController
  def show
    @messages = Chat.all
  end
end
