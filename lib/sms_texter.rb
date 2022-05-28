require 'twilio-ruby'
# adapted for twilio
module SmsTexter

  def self.initialize_connection
    return Twilio::REST::Client.new(
      ENV["TWILIO_API_KEY_SID"],
      ENV["TWILIO_API_KEY_SECRET"],
      ENV["TWILIO_ACCOUNT_SID"]
    )
  end

  def self.send_text text_body, opts = {}
    client = initialize_connection
    options = {
      body: text_body,
      to: ENV["TWILIO_TO_NUMBER"],
      from: ENV["TWILIO_FROM_NUMBER"],
    }
    client.messages.create(options)
  end
end