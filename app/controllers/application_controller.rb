class ApplicationController < ActionController::Base
  # allow the devise controller to do whatever
  before_action :authenticate_user!, only: [:homepage]

  def homepage
  end

  protected

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end

end
