class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:index,:edit, :update,:following,:followers]
  before_filter :correct_user, only: [:edit,:update,:see_reports]
  before_filter :admin_user, only: [:destroy]

  before_filter :get_users_from_params_hash, only: [:show, :destroy, :following, :followers, :see_reports]
  before_filter :get_all_users, only: :index
  before_filter :get_new_user, only: :create
  
  def new
  	@user=User.new
  end

  def show 
    @reports = @user.reports
  end

  def create
  	if @user.save
      sign_in @user
      flash[:success]= "Welcome to the reporting app"
      redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    #done in before filter
    #@user=User.find(params[:id])
  end

  def update
    #done in before filter
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
  end

  def destroy
    @user.destroy
    flash[:success] = "User Destroyed."
    redirect_to users_url
  end

  def search 
    @ret = User.find_by_name(params[:q])
    render 'shared/search_result'
  end 

  def following
    @title = "Following"
    @users = @user.followed_users
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers
    render 'show_follow'
  end

  def see_reports
    @title = "Last Report"
    @users=@user.followed_users
    
    render 'shared/see_reports'
  end

  private 

    def correct_user
      @user = User.where(id: params[:id]).first
      redirect_to root_url unless current_user?(@user)
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def get_users_from_params_hash
      @user = User.where(id: params[:id]).first
      unless @user
        flash[:notice]="User not found!! Returned to home page."
        redirect_to root_url
      end
    end

    def get_all_users
      @users = User.all
    end

    def get_new_user
      @user = User.new(params[:user])
    end
end
