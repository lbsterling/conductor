class ActivationsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => :show
  # require_no_user

  def show
    if @user.activate
      @user.send :create_session!
    else
      flash[:error] = @user.errors.full_messages.to_sentence
    end
    redirect_to root_url
  end

private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account." +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser."
      redirect_to root_url
    end
  end
end
