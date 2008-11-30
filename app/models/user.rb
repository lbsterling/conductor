class User < ActiveRecord::Base
  has_many :user_roles, :dependent => :destroy
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

  # TODO: get rid of this ugly hack to make it possible for the migration to use User model (avoid missing method password)
  def self.act_as_authentic
    acts_as_authentic :login_field_validates_length_of_options => {:within=>1..100,:too_short=>'must be provided'},
                      :login_field_validates_format_of_options => {:message => 'does not look valid',:allow_blank=>true},
                      :password_field_validation_options => {:unless=>:using_openid?,:message=>'or OpenID must be provided'}
  end
  
  act_as_authentic

  validate :normalize_openid_identifier
  validates_uniqueness_of :openid_identifier, :allow_blank => true

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PasswordMailer.deliver_password_reset_instructions(self)
  end

  def using_openid?
    !openid_identifier.blank?
  end

  def has_role?(name)
    roles.any? { |r| r.name == name }
  end

private
  def normalize_openid_identifier
    begin
      self.openid_identifier = OpenIdAuthentication.normalize_url(openid_identifier) if using_openid?
    rescue OpenIdAuthentication::InvalidOpenId => e
      errors.add(:openid_identifier, e.message)
    end
  end

  class <<self
    def human_attribute_name(attribute_key_name, options = {})
      return 'OpenID' if attribute_key_name.to_s == 'openid_identifier'
      super
    end
  end
end
