class UsersController < ApplicationController
  before_action :check_login_status, only: [:edit, :update, :index, :destroy]
  before_action :check_can_view, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Updated user successfully"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def check_login_status
    unless logged_in?
      store_location
      flash[:danger] = "Please login"
      redirect_to login_path
    end
  end

  def check_can_view
    redirect_to root_url if params[:id] != current_user.id.to_s
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
