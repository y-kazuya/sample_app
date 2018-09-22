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

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) #user_idにsession[:user_id]を代入して、user_idがnilじゃなかったら
      @current_user ||= User.find_by(id: user_id) #ここのuser_idはsession[:user_id]が存在した時に上のuser_idに代入した値
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) #userがもつremember_digetsがtokenと一致したら！
        log_in user
        @current_user = user
      end
    end
  end

  def current_user
    if session[:user_id] #ログイン中じゃなかったらnilを返す
      @current_user ||= User.find_by(id: session[:user_id]) #//何回もDBを叩くのを避けるためにこの書き方、ログイン中かつ、@current_userに値がない場合のみコントローラーを叩く
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
