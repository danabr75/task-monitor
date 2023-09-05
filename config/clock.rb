# frozen_string_literal: true

require 'clockwork'
require './config/boot'
require './config/environment'

begin
  module Clockwork
    handler do |job|
      puts "Running #{job}"
    end

    every(1.minute, "Check For Missing Pulses") do
      # Don't want to spam the logs. Only print out if error or status change
      # Rails.logger.info "CLOCK: Executing HerokuWorkerAutoScaler"
      begin
        CheckingForMissingHeartbeatsWorker.perform_async
      rescue Exception => e
        Rails.logger.error "Internal Server Error: Clock Pulses Check Failed!; #{e.class.name}: #{e.message}"
        Rails.logger.error Rails.backtrace_cleaner.clean(e.backtrace).join("\n").to_s
      end
    end
  end
rescue Exception => e
  # without exception catch-and-raise, clock errors will not be caught by log alerts
  Rails.logger.error "Internal Server Error: clock module encountered error; #{e.class.name}: #{e.message}"
  Rails.logger.error e.backtrace
  raise e
end
