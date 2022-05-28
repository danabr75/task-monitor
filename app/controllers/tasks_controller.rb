class TasksController < ApplicationController
  # allow the devise controller to do whatever
  before_action :authenticate_user!, except: [:heartbeat]

  
  def heartbeat
    if params[:token].present?
      t = Task.find_by_token(params[:token])
      t&.mark_active
    end

    Task.check_for_missing_heartbeats

    render json: nil, status: :ok and return
  end

  # if failure detected
  def failure
    if params[:token].present?
      t = Task.find_by_token(params[:token])
      t&.mark_inactive
    end
    Task.check_for_missing_heartbeats
    render json: nil, status: :ok and return
  end
end
