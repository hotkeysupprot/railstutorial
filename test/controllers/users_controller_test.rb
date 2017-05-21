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

end
