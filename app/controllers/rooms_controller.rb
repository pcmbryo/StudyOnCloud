class RoomsController < ApplicationController
  def index
    @rooms = Room.new.find_by_future
  end

  def show

  end

  def new
    @room = Room.new
    @page_title = "勉強会の作成"
  end

  def create

  end

  def edit

  end

  def update

  end

end
