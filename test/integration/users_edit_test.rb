require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit 無効な情報を送信" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name: "",
                                    email: "foo@invalid",
                                    password: "foo",
                                    password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), user: { name:  name,
                                    email: email,
                                    # パスワードを入力せずに更新できる
                                    password: "",
                                    password_confirmation: "" }
    # flashメッセージが空でない
    assert_not flash.empty?
    # プロフィールページにリダイレクトされる
    assert_redirected_to @user
    # データベースから最新のユーザー情報を読み込んでから確認
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end
end
