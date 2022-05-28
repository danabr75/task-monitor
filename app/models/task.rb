class Task < ApplicationRecord

  CONSIDERED_INACTIVE_AFTER = (
    ENV["TASK_INACTIVE_AFTER_MINUTES"].present? ? ENV["TASK_INACTIVE_AFTER_MINUTES"].minutes : 20.minutes
  )

  def self.create_new_task! name
    t = Task.create!(name: name, token: SecureRandom.hex, last_heartbeat_at: Time.now)
    return t.token
  end

  # In lieu of a clock, just check when pinged.
  def self.check_for_missing_heartbeats
    Task.where(sent_alert_notification_at: nil).where("last_heartbeat_at < ?", CONSIDERED_INACTIVE_AFTER.ago).each do |t|
      t.mark_inactive
    end
  end

  def active?
    last_heartbeat_at > CONSIDERED_INACTIVE_AFTER.ago && sent_alert_notification_at.nil?
  end

  def mark_inactive
    self.update!(sent_alert_notification_at: Time.now)
    # if only
    # TaskMailer.send_inactive(self).deliver
  end

  def mark_active
    update!(last_heartbeat_at: Time.now, sent_alert_notification_at: nil)
  end
end
