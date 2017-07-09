require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  # list 9.31
  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in / flashにメッセージが代入されたかどうか、ログイン画面にリダイレクトされたかどうかを確認" do
    # editはGETメソッド
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in / flashにメッセージが代入されたかどうか、ログイン画面にリダイレクトされたかどうかを確認" do
    # updateはPATCHメソッド
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user / ログイン済みのユーザーが別のユーザーを編集しようとするならルートURLにリダイレクト" do
    log_in_as(@other_user)
    get :edit, id: @user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user / ログイン済みのユーザーが別のユーザーを編集しようとするならルートURLにリダイレクト" do
    log_in_as(@other_user)
    patch :update, id: @user, user: { name: @user.name, email: @user.email }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password:              'password',
                                            password_confirmation: 'password',
                                            admin: true }
    assert_not @other_user.reload.admin?  # データベースから最新情報を取得しなおすため reload が必要
  end

  # destroy リスト9.56: 管理者権限の制御をアクションレベルでテストする
  
  test "should redirect destroy when not logged in / ログインしていないユーザーであれば、ログイン画面にリダイレクト" do
    # Userテーブルでレコードは削除されないので、コントローラにDELETEメソッドdestroyアクションを要求しても User.count は変化しないはず
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin / 管理者でなければ、ホーム画面にリダイレクト" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
