class ReservationsController < ApplicationController
  include ApplicationHelper

  # ログインしていないと実行できないアクション
  before_action :logged_in_user, only: [:create, :destroy]

  # 予約
  def create
    reservation = Reservation.new(room_id: params[:room_id], user_id: session[:user_id])
    if reservation.save
      flash[:success] = "予約しました"
      redirect_to room_path(params[:room_id])
    else
      flash[:danger] = "予約に失敗しました"
      redirect_to room_path(params[:room_id])
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
end
