require 'test_helper'

class UsersControllerTest < ActionController::TestCase
=begin
    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create user" do
      assert_difference('User.count') do
        post :create, :user => { }
      end

      assert_redirected_to user_path(assigns(:user))
    end
=end

  test "should require authentication to show user" do
    get :show
    assert_response :redirect
    assert_redirected_to new_session_path
  end

  test "should show user" do
    login_as :one
    get :show
    assert_response :success
  end

=begin
    test "should get edit" do
      get :edit, :id => users(:one).id
      assert_response :success
    end

    test "should update user" do
      put :update, :id => users(:one).id, :user => { }
      assert_redirected_to user_path(assigns(:user))
    end

    test "should destroy user" do
      assert_difference('User.count', -1) do
        delete :destroy, :id => users(:one).id
      end

      assert_redirected_to users_path
    end
=end
  # end
end
