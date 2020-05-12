class UsersController < ApplicationController
  include SessionsHelper
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #ユーザー作成完了後ログインする
      log_in(@user)
      flash[:success] = "新規登録完了しました"
      #redirect_to user_url(@user)はredirect_to userと省略可能
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation)
    end
end
