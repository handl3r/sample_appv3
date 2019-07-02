# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def index
    @users = User.paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome new user'
      redirect_to user_url(@user)
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
      flash[:success] = 'Your information be updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  before_action :logged_in_user, only: %i[index update edit]
  before_action :correct_user, only: %i[update edit]
  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please login before!'
      redirect_to login_path
    end
  end

  def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
