class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, :through => :user_roles

  has_states :unregistered, :registered, :active do
    on :register do
      transition :unregistered => :registered
    end
    on :activate do
      transition :registered => :active
      transition :unregistered => :active
    end
  end

  acts_as_authentic :password_field_validation_options => {:unless => :using_openid?}

  validate :normalize_openid_identifier
  validates_uniqueness_of :openid_identifier, :allow_blank => true

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PasswordMailer.deliver_password_reset_instructions(self)
  end

  def using_openid?
    !openid_identifier.blank?
  end

private
  def normalize_openid_identifier
    begin
      self.openid_identifier = OpenIdAuthentication.normalize_url(openid_identifier) if using_openid?
    rescue OpenIdAuthentication::InvalidOpenId => e
      errors.add(:openid_identifier, e.message)
    end
  end
end
