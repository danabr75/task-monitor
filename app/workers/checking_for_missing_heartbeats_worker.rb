class CheckingForMissingHeartbeatsWorker
  include Sidekiq::Worker
  
  def perform
    Task.check_for_missing_heartbeats
  end
end
