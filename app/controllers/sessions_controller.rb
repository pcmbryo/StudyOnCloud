class SessionsController < ApplicationController
  include ApplicationHelper

  # ログイン画面
  def new
    if logged_in?
      redirect_to current_user
    end
    @page_title = "ログイン"
  end

  # ログイン
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if !user.nil? && user.authenticate(params[:session][:password])
      #log_inメソッドはapplication_helper.rbに定義
      log_in user
      flash[:success] = user.user_name + "でログインしました"
      #redirect_to user
      redirect_back_or root_path
    else
      flash.now[:danger] = "メールアドレスとパスワードの組み合わせが正しくありません"
      render 'new'
    end
  end

  # ゲストでログイン
  def guest
    user = User.find_by(email: "guest@sysdog.com")
    if user.nil?
      flash[:danger] = "ゲストでログインできませんでした"
      redirect_to login_path
    else
      log_in user
      flash[:success] = "ゲストでログインしました"
      redirect_back_or root_path
    end
  end

  # ログアウト
  def destroy
    log_out
    redirect_to login_path
  end
end
