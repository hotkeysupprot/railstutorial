module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    # ブラウザ内の一時cookiesに暗号化済みのユーザーIDが作成される
    session[:user_id] = user.id
  end

  # ユーザーを永続的セッションに記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログインしているユーザーを返す (ユーザーがログイン中の場合のみ)
  def current_user
    # @current_user ||= User.find_by(id: session[:user_id])
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        # 一時セッションを作成しログイン状態にする
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    # 永続的セッションを破棄
    forget(current_user)
    # セッションからもユーザーIDを削除
    session.delete(:user_id)
    # 現在のユーザーをnilにする。セキュリティ上の死角を万が一にでも作り出さないためにあえてnilに設定。
    @current_user = nil
  end
end
