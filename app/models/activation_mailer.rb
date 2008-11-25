class ActivationMailer < ActionMailer::Base
  default_url_options[:host] = APP_CONFIG[:hostname]

  def account_activation_instructions(user)
    subject       "Account Activation Instructions"
    from          "#{APP_CONFIG[:site_name]} <#{APP_CONFIG[:noreply_email]}>"
    recipients    user.email
    sent_on       Time.now
    body          :activation_url => activation_url(user.perishable_token)
  end
end
