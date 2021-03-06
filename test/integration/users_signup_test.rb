require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  # 不正なユーザー作成
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: {name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar"}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  # ユーザー作成成功
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      # post_via_redirectメソッド: POSTリクエストを送信し、リダイレクトする。複数回リダイレクトがあるなら最後まで行く。
      post_via_redirect users_path, user: {name: "Example User",
                                           email: "user@example.com",
                                           password: "password",
                                           password_confirmation: "password"}
    end
    assert_template 'users/show'
    # ユーザー登録の終わったユーザーがログイン状態になっていること
    assert is_logged_in?
    assert_not flash.empty?
  end
end
