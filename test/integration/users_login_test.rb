require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    # フィクスチャusers.yml にて、テスト用ユーザーを取得。パスワードはpassword固定
    @user = users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: { email: "", password: "" }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    # 移動先のページでフラッシュメッセージが表示されていないことを確認する
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    # ログイン用のパスを開く
    get login_path
    # セッション用パスに有効な情報をpostする
    post login_path, session: { email: @user.email, password: 'password' }
    # 本当にログインできたかチェック
    assert is_logged_in?
    # リダイレクト先が正しいこと
    assert_redirected_to @user
    # 実際にそのページに移動
    follow_redirect!
    assert_template 'users/show'
    # ログイン用リンクが表示されなくなっていること
    assert_select "a[href=?]", login_path, count: 0
    # ログアウト用リンクが表示されていること
    assert_select "a[href=?]", logout_path
    # プロフィール用リンクが表示されていること
    assert_select "a[href=?]", user_path(@user)

    # ログアウト。アクション呼び出しがそのまま直接ログアウト処理になる（入力画面が無い）
    delete logout_path
    assert_not is_logged_in?
    # リダイレクト先をチェック
    assert_redirected_to root_url
    # 2番目のウィンドウでログアウトをクリックするユーザーをシミュレートする
    delete logout_path
    # 実際にリダイレクトします
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
