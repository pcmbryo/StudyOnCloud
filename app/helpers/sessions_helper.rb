module SessionsHelper
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

	#記憶したURL（もしくはデフォルト値）にリダイレクト
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	#アクセスしようとしたURLを覚えておく
	def store_location
		if request.get?
			session[:forwarding_url] = request.original_url
		end
	end
end