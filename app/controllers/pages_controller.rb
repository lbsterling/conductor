class PagesController < ApplicationController
  before_filter :store_location

  def index
    if current_user
      if current_user.has_role? 'Administrator'
        redirect_to :controller => 'admin/documents'
      else
        redirect_to :controller => 'documents'
      end
    end
  end
end
