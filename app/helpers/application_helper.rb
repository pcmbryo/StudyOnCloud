module ApplicationHelper
  # コントローラから受け取ったページタイトルに"スタクラ"を付与してviewへ渡す
  def page_title
    title = "スタクラ"
    title = @page_title + " / " + title if @page_title
    title
  end

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを取得
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  # ユーザーがログインしていればtrue,それ以外はfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # ログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:current_url] || default)
    session.delete(:current_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:current_url] = request.referer
  end

  # ログインしているかを確認
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_url
    end
  end

  # オブジェクトがもつエラーメッセージをフラッシュに格納する
  def error_to_flush object
    if object.errors.any?
      error_messages = ""
      object.errors.full_messages.each do |msg| 
        error_messages += msg.to_s + "<br>"
        #出力の際に(.html_safe)をつけると<br>が機能する。=> shared/_flash.html.erbに追加済み
      end
      flash[:danger] = error_messages
    end
  end

  # オブジェクトがもつエラーメッセージをフラッシュに格納する(render用)
  def error_to_flush_now object
    if object.errors.any?
      error_messages = ""
      object.errors.full_messages.each do |msg| 
        error_messages += msg.to_s + "<br>"
        #出力の際に(.html_safe)をつけると<br>が機能する。=> shared/_flash.html.erbに追加済み
      end
      flash.now[:danger] = error_messages
    end
  end
end
