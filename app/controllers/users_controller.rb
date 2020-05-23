class UsersController < ApplicationController
  include SessionsHelper
  # ログインしていないと実行できないアクション
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @page_title = "ユーザー詳細"
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
      if @user.errors.any?
        errormessages = ""
        @user.errors.full_messages.each do |msg| 
          errormessages += msg.to_s
          errormessages += "<br>"
          #出力の際に(.html_safe)をつけると<br>が機能する。=> shared/_flash.html.erbに追加済み
        end
        flash[:danger] = errormessages
      end
      redirect_to new_user_path
    end
  end

  #GET /users/:id/editのとき編集
  def edit
    @page_title = "編集"
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

    #ログインしているかを確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
    
    #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        flash[:danger] = "他ユーザーを編集することはできません"
        redirect_to user_url(@user)
      end
    end
end
