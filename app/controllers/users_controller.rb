# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
  end
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    unless @user.activated?
      flash[:danger] = "This account is not activated"
      redirect_to root_url
    end
    #redirect_to root_url and return unless @user.activated?
    # debugger
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:infor] = 'Please check your email to activate your account.'
      redirect_to root_url
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
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  before_action :logged_in_user, only: %i[index update edit destroy]
  before_action :correct_user, only: %i[update edit]
  before_action :admin_user, only: :destroy
  private

  def correct_user
     @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


end
