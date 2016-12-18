class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # ログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # ログアウト処理としてsessions_helper.rbのlog_outメソッドを利用
    log_out
    # すぐrootにリダイレクト
    redirect_to root_url
  end
end
