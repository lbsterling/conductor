class Admin::AdminController < ApplicationController
  require_role 'Administrator'
  before_filter :store_location

private
  def nav
    [
      ['Documents', admin_documents_path],
      ['Users', admin_users_path]
    ]
  end

  def current_nav
    controller_name.camelize
  end
end
