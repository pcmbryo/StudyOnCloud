module ApplicationHelper
  # コントローラから受け取ったページタイトルに"スタクラ"を付与してviewへ渡す
  def page_title
    title = "スタクラ"
    title = @page_title + " | " + title if @page_title
    title
  end

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    session[:user_name] = user.user_name
  end

  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  #ユーザーがログインしていればtrue,それ以外はfalseを返す
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
