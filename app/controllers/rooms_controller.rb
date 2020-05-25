class RoomsController < ApplicationController
  def index
    @rooms = Room.new.find_by_future
  end
end
