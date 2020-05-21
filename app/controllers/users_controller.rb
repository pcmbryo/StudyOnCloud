class UsersController < ApplicationController
  include SessionsHelper
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @page_title = "新規登録"
  end

  #POST users/:id
  def create
    @user = User.new(user_params)
    if @user.save
      #ユーザー作成完了後ログインする
      log_in(@user)
      flash[:success] = "新規登録完了しました"
      #redirect_to user_url(@user)はredirect_to userと省略可能
      redirect_to user_url(@user)
    else
      redirect_to '/users/new'
    end
  end

  #GET /users/:id/editのとき編集
  def edit
    @user = User.find(params[:id])
    #ユーザーアイコン画像のネーミングのための変数を宣言
    $user_image_id = 'image_' + session[:user_id].to_s
  end

  #PATCH users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      $user_image_id = nil
      redirect_to user_url(@user)
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :image, :introduction)
    end
end
