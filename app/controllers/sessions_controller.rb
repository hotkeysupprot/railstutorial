class SessionsController < ApplicationController
  def new
  end

  def create
    # ローカル変数user でなくインスタンス変数@user であれば、
    # インテグレーションテストtest/integration/users_login_test.rb において
    # remember_token属性にアクセスできるようになる。つまりassigns(:user).remember_token を用いる。
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # ログイン後にユーザー情報のページにリダイレクトする、のはやめてフレンドリーフォワーディング
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # ログアウト処理としてsessions_helper.rbのlog_outメソッドを利用
    log_out if logged_in?
    # すぐrootにリダイレクト
    redirect_to root_url
  end
end
