class UsersController < ApplicationController
  # ログインユーザーでなければならないアクションを記述する。
  # ログインしていないと認可のチェック(このbefore_action)に引っかかりログインURL
  # にリダイレクトされるテストは、users_controller_test.rbでおこなう。
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  # 自分自身に対する操作でなければならないアクションを記述する（別ユーザーの編集を防止する）
  before_action :correct_user, only: [:edit, :update]
  
  # 管理者だけが実行できるアクションを記述する。
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # ユーザー登録が成功したらそのままログインまで済ませておく
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url # ユーザーインデックスに移動
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # ログイン済みユーザーかどうかチェック
  def logged_in_user
    unless logged_in?
      # フレンドリーフォワーディングに備えてURLを記憶しておく
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # 操作対象ユーザーが自分自身であるかチェック
  def correct_user
    @user = User.find(params[:id])
    # current_user? はセッションヘルパー
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者チェック
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
