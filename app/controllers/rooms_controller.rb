class RoomsController < ApplicationController
  include ApplicationHelper

  # ログインしていないと実行できないアクション
  before_action :logged_in_user, except: [:index, :show]

  # 勉強会作成画面
  def new
    @page_title = "勉強会の作成"
    @room = Room.new
  end

  # 勉強会一覧画面
  def index
    @rooms = Room.home_index
  end

   # 勉強会詳細画面
  def show
    @page_title = "勉強会詳細"
    @room = Room.find(params[:id])
  end

  def confirm
    
  end

  # 勉強会作成
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

  # 勉強会削除
  def destroy
    room = Room.find(params[:id])
    room.room_delete_flg = 1
    if room.save
      flash[:success] = "勉強会を削除しました"
      redirect_to root_path
    else

    end
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
