# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @other_user = users(:test1)
  end
  test 'should get new' do
    get signup_path
    assert_response :success
  end
  # test can edit and update information when not logged in
  test 'should redirect to edit if not login' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path # the same as login_url
  end
  test 'should redirect to update if not login' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  # test another user can edit and update information of diffrent users
  test 'should redirect to edit if wrong login' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_path
  end
  test 'should redirect to update if wrong login' do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name, email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @other_user.admin?
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should  redirect destroy when logged in as non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  test 'should redirect to following when not logged in' do
    get following_user_path(@user)
    assert_redirected_to root_url
  end
  test 'shot redirect to followers when not logged in' do
    get followers_user_path(@user)
    assert_redirected_to root_url
  end
end
