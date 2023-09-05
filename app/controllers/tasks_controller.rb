class TasksController < ApplicationController
  # allow the devise controller to do whatever
  before_action :authenticate_user!, except: [:heartbeat, :failure]


  def heartbeat
    if params[:token].present?
      t = Task.find_by_token(params[:token])
      t&.mark_active
    end

    render json: nil, status: :ok and return
  end

  # if failure detected
  def failure
    if params[:token].present?
      t = Task.find_by_token(params[:token])
      t&.mark_inactive
    end

    render json: nil, status: :ok and return
  end

  def mark_as_active
    t = Task.find(params[:id])
    t&.mark_active
    redirect_to root_url
  end

  def mark_as_ignore
    t = Task.find(params[:id])
    t&.mark_ignore
    redirect_to root_url
  end

  def mark_as_unignore
    t = Task.find(params[:id])
    t&.mark_unignore
    redirect_to root_url
  end
end
