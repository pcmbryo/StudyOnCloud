class RoomsController < ApplicationController
  include ApplicationHelper

  # ログインしていないと実行できないアクション
  before_action :logged_in_user, except: [:index, :show]
  before_action :correct_room, only: [:edit, :update, :delete]

  # 勉強会作成画面
  def new
    @page_title = "勉強会の作成"
    @room_confirm = RoomConfirm.new
  end

  # 勉強会一覧画面
  def index
    @rooms = Room.home_index
  end

   # 勉強会詳細画面
  def show
    @page_title = "勉強会詳細"
    @room = Room.find(params[:id])
    # 参加者一覧を取得
    @guests = Reservation.where(room_id: params[:id])
  end

  # 作成確認画面
  def confirm
    @page_title = "勉強会の作成確認"
    room_confirm = RoomConfirm.new(room_confirm_params)
    session[:room_name] = room_confirm.room_name
    session[:room_detail] = room_confirm.room_detail
    session[:room_start_date] = room_confirm.room_start_date
    session[:room_start_time] = room_confirm.room_start_time
    session[:room_end_date] = room_confirm.room_end_date
    session[:room_end_time] = room_confirm.room_end_time
    session[:room_capacity] = room_confirm.room_capacity
    if room_confirm.invalid?
      error_to_flush room_confirm
      redirect_to new_room_path
    else
      @room = parse_room(room_confirm)
      if @room == nil
        redirect_to new_room_path
      else
        render :confirm
      end
    end
  end

  # 勉強会作成
  def create
    room = Room.new(room_params)
    if params[:back]
      redirect_to new_room_path
    elsif room.save
      session.delete(:room_name)
      session.delete(:room_detail)
      session.delete(:room_start_date)
      session.delete(:room_start_time)
      session.delete(:room_end_date)
      session.delete(:room_end_time)
      session.delete(:room_capacity)
      flash[:success] = "以下の内容で作成しました"
      redirect_to room
    else
      error_to_flush room
      redirect_to new_room_path
    end
  end

  # 勉強会編集画面
  def edit
    @page_title = "勉強会編集"
    @room = Room.find(params[:id])
  end

  # 勉強会編集
  def update
    room = Room.find(params[:id])
    if room.update(room_params)
      redirect_to room
    else
      error_to_flush room
      redirect_to room
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
      flash[:danger] = "削除に失敗しました"
      redirect_to room
    end
  end

  private
    def room_params
      params.require(:room)
        .permit(:room_name,
        :room_detail,
        :room_start_datetime,
        :room_end_datetime,
        :room_capacity,
        :user_id)
    end

    def room_confirm_params
      params.require(:room_confirm)
        .permit(:room_name,
        :room_detail,
        :room_start_date,
        :room_start_time,
        :room_end_date,
        :room_end_time,
        :room_capacity).
        merge(user_id: current_user.id)
    end

    def correct_room
      room = Room.find(params[:id])
      unless room.user_id == session[:user_id]
        redirect_to room
      end
    end
    
    # 入力用データから保存用データへ変換する
    def parse_room(room_confirm)
      room_start_datetime = Time.zone.parse(room_confirm.room_start_date + " " + room_confirm.room_start_time)
      room_end_datetime = Time.zone.parse(room_confirm.room_end_date + " " + room_confirm.room_end_time)

      host_rooms = Room.host_plans(session[:user_id])
      guest_rooms = Room.guest_plans(session[:user_id])
      
      if room_start_datetime < Time.zone.now
        flash[:danger] = "現在時刻より前に勉強会は開催できません"
        return
      end

      if room_start_datetime >= room_end_datetime
        flash[:danger] = "終了日時が開始日時より前になっています"
        return
      end

      host_rooms.each do |room|
        if (room.room_start_datetime > room_start_datetime && room.room_start_datetime < room_end_datetime) || (room.room_end_datetime > room_start_datetime && room.room_end_datetime < room_end_datetime)
          flash[:danger] = "開催または参加予定の勉強会と日時が重複しています"
        return
        end
      end

      guest_rooms.each do |room|
        if (room.room_start_datetime > room_start_datetime && room.room_start_datetime < room_end_datetime) || (room.room_end_datetime > room_start_datetime && room.room_end_datetime < room_end_datetime)
          flash[:danger] = "開催または参加予定の勉強会と日時が重複しています"
        return
        end
      end

      room = Room.new(room_name: room_confirm.room_name,
        room_detail: room_confirm.room_detail,
        room_start_datetime: room_start_datetime,
        room_end_datetime: room_end_datetime,
        room_capacity: room_confirm.room_capacity,
        user_id: room_confirm.user_id)
      
      return room
    end
end
