class UserObserver < ActiveRecord::Observer
  def after_enter_registered(user)
    ActivationMailer.deliver_account_activation_instructions(user)
  end
end
