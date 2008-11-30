class UsersController < ApplicationController
  # require_no_user :only => [:new, :create]
  require_user :only => [:show, :edit, :update]
  before_filter :store_location, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  # TODO: in order to validate (ie. authenticate) openid when creating user,
  #       we need to be able to persist (possibly invalid) users and then authenticate,
  #       then we can use the returned profile info to complete any missing data in the user
  #       otherwise, the user information (which could include the password) would have to be
  #       included in the return_to url... the trick is purging users that don't get completely created
  def create
    @user = User.new(params[:user])
    if @user.save && @user.register
      flash[:notice] = "Account registered!"
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
