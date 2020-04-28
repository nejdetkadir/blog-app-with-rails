class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def show    
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and all articles created by user have been deleted"
    redirect_to users_path
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def new
    if logged_in?
      flash[:notice] = "Your have already sign up."
      redirect_to user_path(current_user)
    else
      @user = User.new
    end    
  end
  
  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your account information was successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    #byebug
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to the My blog #{@user.username}. You have successfully signed up"
      redirect_to articles_path
    else
      render 'new'
    end
  end

  private  
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit or delete your own account!"
      redirect_to root_path
    end    
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admins can perform that action!"
      redirect_to root_path
    end
  end

end