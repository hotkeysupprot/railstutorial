require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end
  
  # test "index including pagination" do
  #   log_in_as(@user)
  #   get users_path
  #   assert_template 'users/index'
  #   assert_select 'div.pagination'
  #   User.paginate(page: 1).each do |user|
  #     assert_select 'a[href=?]', user_path(user), text: user.name
  #   end
  # end

  test "index as admin including pagination and delete links / ページネーションと削除リンクを同時にテスト" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      # ユーザー名リンクが表示される
      assert_select 'a[href=?]', user_path(user), text: user.name
      
      # 自分以外の削除リンクが表示される
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    
    # 前後でusersテーブルのレコード数に -1 の変化がある
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin / 管理者以外なら削除リンクがないこと" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
