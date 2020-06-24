class ReservationsController < ApplicationController
  include ApplicationHelper

  # ログインしていないと実行できないアクション
  before_action :logged_in_user, only: [:create, :destroy]

  # 予約
  def create
    reservation = Reservation.new(room_id: params[:room_id], user_id: session[:user_id])

    resevation_room = Room.find(params[:room_id])

    if !check_datetime?(resevation_room)
      flash[:danger] = "開催または参加予定の勉強会と日時が重複しています"
      redirect_to resevation_room
      return
    end

    if reservation.save
      flash[:success] = "予約しました"
      redirect_to resevation_room
    else
      flash[:danger] = "予約に失敗しました"
      redirect_to resevation_room
    end
  end
  
  # キャンセル
  def destroy
    reservation = Reservation.find_by(room_id: params[:room_id], user_id: session[:user_id])
    if reservation.destroy
      flash[:success] = "キャンセルしました"
      redirect_to room_path(params[:room_id])
    else
      flash[:danger] = "キャンセルに失敗しました"
      redirect_to room_path(params[:room_id])
    end
  end

  private
    def check_datetime?(resevation_room)
      Room.host_plans(session[:user_id]).each do |room|
        if (room.room_start_datetime >= resevation_room.room_start_datetime && room.room_start_datetime <= resevation_room.room_end_datetime) || (room.room_end_datetime >= resevation_room.room_start_datetime && room.room_end_datetime <= resevation_room.room_end_datetime)
        return false
        end
      end

      Room.guest_plans(session[:user_id]).each do |room|
        if (room.room_start_datetime >= resevation_room.room_start_datetime && room.room_start_datetime <= resevation_room.room_end_datetime) || (room.room_end_datetime >= resevation_room.room_start_datetime && room.room_end_datetime <= resevation_room.room_end_datetime)
        return false
        end
      end
      return true
    end
end
