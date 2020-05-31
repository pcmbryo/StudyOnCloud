class RoomsController < ApplicationController
  include ApplicationHelper

  # ログインしていないと実行できないアクション
  before_action :logged_in_user, except: [:index, :show]

  def index
    
  end

  def show
    @page_title = "勉強会詳細"
    @room = Room.find(params[:id])
  end

  def new
    @page_title = "勉強会の作成"
    @room = Room.new
  end

  def confirm
    
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      flash[:success] = "以下の内容で作成しました"
      redirect_to @room
    else
      error_to_flush @room
      redirect_to new_room_path
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private
    def room_params
      params.require(:room)
        .permit(:room_name,
        :room_detail, 
        :room_start_datetime, 
        :room_end_datetime, 
        :room_capacity)
        .merge(user_id: current_user.id)
    end
end
