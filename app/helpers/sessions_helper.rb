module SessionsHelper
   # 渡されたユーザーでログインする
   def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id] #ログイン中じゃなかったらnilを返す
      @current_user ||= User.find_by(id: session[:user_id]) #//何回もDBを叩くのを避けるためにこの書き方、ログイン中かつ、@current_userに値がない場合のみコントローラーを叩く
    end
  end

  def logged_in?  ## ログインしてる？
    !current_user.nil?  #!がついてるのでcurrent_userが存在したらtrueそれ以外はfalseを返す
  end

  # 現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
