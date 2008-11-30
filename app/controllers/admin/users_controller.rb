class Admin::UsersController < Admin::AdminController
  def index
    @users = User.paginate :page => params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:document])
  end
  
  def show
    @user = User.find(params[:id])
  end
end
