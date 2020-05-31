class UsersController < ApplicationController
  include ApplicationHelper
  
  # ログインしていないと実行できないアクション
  before_action :logged_in_user, only: [:update]
  before_action :correct_user, only: [:update]

  # GET /uesrs/:id
  def show
    @page_title = "ユーザー詳細"
    @user = User.find(params[:id])
    $user_image_id = 'image_' + session[:user_id].to_s
  end

  # GET /users/new
  def new
    @page_title = "新規登録"
    # ログインしていた場合マイページに遷移
    if logged_in?
      redirect_to current_user
    end
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      #ユーザー作成完了後ログインする
      log_in(@user)
      flash[:success] = "新規登録完了しました"
      #redirect_to user_url(@user)はredirect_to userと省略可能
      redirect_to user_url(@user)
    else
      error_to_flush @user
      redirect_to new_user_path
    end
  end

  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      $user_image_id = nil
      redirect_to user_url(@user)
    else
      flash[:danger] = "ユーザー情報の編集に失敗しました"
      redirect_to user_url(@user)
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :email, :password, :password_confirmation, :image, :introduction)
    end
    
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:danger] = "他のユーザーを編集することはできません"
        redirect_to user_url(@user)
      end
    end
end
