class UserSessionsController < ApplicationController
  # require_no_user :only => [:new, :create]
  require_user :only => :destroy

  OpenIdAuthentication::Result::ERROR_MESSAGES.merge!({
    :missing      => "server couldn't be found",
    :invalid      => 'does not appear to be valid',
    :canceled     => "verification was canceled",
    :failed       => "verification failed",
    :setup_needed => "verification needs setup"
  })

  def new
    @user_session = UserSession.new
    @use_openid = false
    flash.now[:notice] = 'Please provide your email/password or OpenID to log in!'
  end
  
  def create
    current_user_session.destroy if current_user
    @use_openid = (params[:use_openid].to_i != 0)
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Log in successful!"
        redirect_back_or_default root_url
      else
        if @user_session.errors.on(:email) || @user_session.errors.on(:password)
          @user_session.errors.add(:email, '')
          @user_session.errors.add(:password, '')
          flash.now[:error] = 'Log in failed!'
        else
          flash.now[:error] = @user_session.errors.full_messages.to_sentence
        end
        render :action => :new
      end
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Log out successful!"
    redirect_back_or_default new_session_url
  end
end
