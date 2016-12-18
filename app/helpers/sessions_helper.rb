module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    # ブラウザ内の一時cookiesに暗号化済みのユーザーIDが作成される
    session[:user_id] = user.id
  end

  # 現在ログインしているユーザーを返す (ユーザーがログイン中の場合のみ)
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    # セッションからユーザーIDを削除
    session.delete(:user_id)
    # 現在のユーザーをnilにする。セキュリティ上の死角を万が一にでも作り出さないためにあえてnilに設定。
    @current_user = nil
  end
end
