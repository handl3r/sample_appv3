# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:test)
  end
  # test 'unsucessful edit' do
  #   log_in_as(@user)
  #   get edit_user_path(@user)
  #   assert_template 'users/edit'
  #   patch user_path(@user), params: { user: { name: '', email: 'invalid@email',
  #                                             password: 'pass1',
  #                                             password_confirmation: 'pass2' } }
  #   assert_template 'users/edit'
  #   assert_select 'div#error_explanation'
  #   assert_select 'div.alert'
  # end
  test "successful edit with friendly forwarding" do

    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "newtest"
    email = "new@test.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "testtest",
                                              password_confirmation: "testtest" } }
    assert_not flash.empty?
    assert_redirected_to session[:forwarding_url]
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

  test 'successful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'test'
    email = 'test@gmail.com'
    patch user_path(@user), params: { user: { name: name, email: email,
                                              password: 'testtest',
                                              password_confirmation: 'testtest' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
