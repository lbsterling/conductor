class PasswordMailer < ActionMailer::Base
  default_url_options[:host] = APP_CONFIG[:hostname]

  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "#{APP_CONFIG[:site_name]} <#{APP_CONFIG[:noreply_email]}>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_url => edit_password_url(user.perishable_token)
  end
end