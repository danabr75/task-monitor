require 'sendpulse/smtp'

class Task < ApplicationRecord

  CONSIDERED_INACTIVE_AFTER = 10.minutes

  def self.create_new_task! name
    t = Task.create!(name: name, token: SecureRandom.hex, last_heartbeat_at: Time.now)
    return t.token
  end

  # In lieu of a clock, just check when pinged.
  def self.check_for_missing_heartbeats
    Task.where(sent_alert_notification_at: nil).where("last_heartbeat_at > ?", CONSIDERED_INACTIVE_AFTER.ago).each do |t|
      t.mark_inactive
    end
  end

  def active?
    last_heartbeat_at > CONSIDERED_INACTIVE_AFTER.ago
  end

  def mark_inactive
    self.update!(sent_alert_notification_at: Time.now)
    # send email or text alert
    # - https://sendpulse.com/integrations/api
    # - https://github.com/sendpulse/sendpulse-rest-api-ruby
    # - https://login.sendpulse.com/settings/#api
    email = {
      html: "<html><body><h1>#{self.name} Inactive</h1></body></html>",
      text: self.name,
      subject: "#{self.name} Inactive",
      from: {
        name: 'Sender',
        email: ENV["DEFAULT_FROM_ADDRESS"]
      },
      to: [
        {
          name: "Reciever",
          email: ENV["DEFAULT_TO_ADDRESS"]
        }
      ]
    }

    sendpulse_smtp = SendPulse::Smtp.new(ENV["EMAIL_CLIENT_ID"], ENV["EMAIL_CLIENT_SECRET"], 'https', nil)
    sendpulse_smtp.send_email(email)
  end

  def mark_active
    self.update!(last_heartbeat_at: Time.now, sent_alert_notification_at: nil)
  end
end
