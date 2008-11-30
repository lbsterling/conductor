require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_many :user_roles
  should_have_many :roles, :through => :user_roles
end
