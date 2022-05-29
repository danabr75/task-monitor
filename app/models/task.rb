class Task < ApplicationRecord

  CONSIDERED_INACTIVE_AFTER = (
    ENV["TASK_INACTIVE_AFTER_MINUTES"].present? ? ENV["TASK_INACTIVE_AFTER_MINUTES"].minutes : 20.minutes
  )

  scope :ordered_by_name, -> { order(name: :asc) }
  scope :ignored, -> { where(ignore: true) }
  scope :unignored, -> { where(ignore: [false, nil]) }
  has_many :ignorable_windows

  def self.temp_ignored_ids
    ids = []
    includes(:ignorable_windows).all.each do |t|
      t.ignorable_windows.each do |iw|
        if iw.time_window_active?
          ids << t.id
        end
      end
    end
    return ids
  end

  def is_temp_ignored?
    result = false
    ignorable_windows.each do |iw|
      if iw.time_window_active?
        result = true
        break
      end
    end
    return result
  end

  def self.temp_ignored
    where(id: temp_ignored_ids)
  end
  def self.temp_unignored
    where.not(id: temp_ignored_ids)
  end

  def temp_time_windows
    result = ""
    ignorable_windows.pluck(:start_time, :stop_time).each do |group|
      result << "#{group[0]}-#{group[1]}\n"
    end
    return result
  end

  def self.create_new_task! name
    t = Task.create!(name: name, token: SecureRandom.hex, last_heartbeat_at: Time.now.utc)
    return t.token
  end

  def create_new_ignorable_window! start_time, stop_time
    ignorable_windows.create!({
      start_time: start_time,
      stop_time: stop_time,
    })
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
    # ignore deliberate calls for inactivity if in expected ignored time range
    if is_temp_ignored?
      # do nothing
    else
      self.update!(sent_alert_notification_at: Time.now.utc)
      if ignore != true
        # TaskMailer.send_inactive(self).deliver
        if ENV["ENABLE_SMS"] == "true"
          SmsTexter.send_text("#{self.name} - Marked Inactive")
        end
      end
    end
    return true
  end

  def mark_active
    update!(last_heartbeat_at: Time.now.utc, sent_alert_notification_at: nil)
  end

  def mark_ignore
    update!(ignore: true)
  end
  def mark_unignore
    update!(ignore: false)
  end
end
