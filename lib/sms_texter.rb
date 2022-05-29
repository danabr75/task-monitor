require 'twilio-ruby'
# adapted for twilio
module SmsTexter

  def self.initialize_connection
    # # for production (maybe, untested)
    # return Twilio::REST::Client.new(
    #   ENV["TWILIO_API_KEY_SID"],
    #   ENV["TWILIO_API_KEY_SECRET"],
    #   ENV["TWILIO_ACCOUNT_SID"]
    # )
    # for sandbox
    return client = Twilio::REST::Client.new(
      ENV["TWILIO_ACCOUNT_SID"],
      ENV["TWILIO_AUTH_TOKEN"]
    )
  end

  def self.send_text text_body, opts = {}
    client = initialize_connection
    # options = {
    #   body: text_body,
    #   to: ENV["TWILIO_TO_NUMBER"],
    #   from: ENV["TWILIO_FROM_NUMBER"],
    # }
    # client.messages.create(options)
    client.messages.create(
      from: ENV["TWILIO_FROM_NUMBER"],
      to: ENV["TWILIO_TO_NUMBER"],
      body: text_body
    )
  end
end