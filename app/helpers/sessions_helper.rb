module SessionsHelper
   # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember  # remembeer_digestの作成
    cookies.permanent.signed[:user_id] = user.id #cokie作成
    cookies.permanent[:remember_token] = user.remember_token  #トークン作成 user.rememberで作ったトークンを保存このcookieはuserのremmber_digesっと比較さsる
  end

   # 現在ログイン中のユーザーを返す (いる場合)
   def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?  ## ログインしてる？
    !current_user.nil?  #!がついてるのでcurrent_userが存在したらtrueそれ以外はfalseを返す
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user?(user)  #正しいユーザーかどうか検証してる
    user == current_user
  end

  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end
