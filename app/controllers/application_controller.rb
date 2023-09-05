class ApplicationController < ActionController::Base
  # allow the devise controller to do whatever
  before_action :authenticate_user!
  before_action :check_for_missing_pulses, unless: -> { Rails.configuration.clock_or_workers_running }

  def homepage
  end

  protected

  def check_for_missing_pulses
    CheckingForMissingHeartbeatsWorker.new.perform
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to new_user_session_path
    end
  end

end
