class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) #存在するユーザーかつpasswordが一致
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      remember user #ユーザをcookieで保存
      log_in user #login メソッドを呼び出してる
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #remember me checkbox が1の時cookie記憶 そのほかの時wasureu]
      redirect_to user
    else
      # エラーメッセージを作成する
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? #ログイン中のみログアウトバグ回避のため
    redirect_to root_url
  end
end