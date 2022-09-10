require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskMonitor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # config.eager_load_paths += %W(#{Rails.root}/lib #{Rails.root}/lib/concerns #{Rails.root}/lib/middleware #{Rails.root}/app/workers/)
    config.eager_load_paths += %W(#{Rails.root}/lib #{Rails.root}/lib/concerns)

    # config.time_zone = "UTC"
    # config.active_record.default_timezone = :utc
    # config.time_zone = 'Eastern Time (US & Canada)'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    host = ENV["HOST_DOMAIN"] || "localhost"

    # # GMAIL - WORKED LOCALLY, BUT NOT ON HEROKU
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.perform_deliveries = true
    # # UPDATE: (See answer below for details) now you need to enable "less secure apps" on your Google Account
    # # https://myaccount.google.com/lesssecureapps?pli=1
    # host = ENV["HOST_DOMAIN"] #replace with your own url
    # config.action_mailer.default_url_options = { host: host }
    # config.action_mailer.smtp_settings = {
    #   :user_name => ENV["GMAIL_USERNAME"],
    #   :password => ENV["GMAIL_PASSWORD"],
    #   # :domain => 'yourdomain.com',
    #   domain: 'gmail.com',
    #   :address => 'smtp.gmail.com',
    #   :port => 587,
    #   :authentication => :plain,
    #   # :enable_starttls_auto => true
    # }

    # sendgrid twilio
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.perform_deliveries = true
    # host = ENV["HOST_DOMAIN"] #replace with your own url
    # config.action_mailer.default_url_options = { host: host }
    # config.action_mailer.smtp_settings = {
    #   # :user_name => 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
    #   # :password => '<SENDGRID_API_KEY>', # This is the secret sendgrid API key which was issued during API key creation
    #   user_name: ENV["SENDGRID_USERNAME"],
    #   password: ENV["SENDGRID_PASSWORD"],
    #   :domain => 'yourdomain.com',
    #   :address => 'smtp.sendgrid.net',
    #   :port => 587,
    #   :authentication => :plain,
    #   :enable_starttls_auto => true
    # }

    # mailtrap - https://devcenter.heroku.com/articles/mailtrap#using-with-rails-3-x-6-x
    # if Rails.env.production?
    #   require 'rest-client'
    #   require 'json'
    #   response = RestClient.get "https://mailtrap.io/api/v1/inboxes.json?api_token=#{ENV['MAILTRAP_API_TOKEN']}"
    #   first_inbox = JSON.parse(response)[0] # get first inbox
    #   config.action_mailer.delivery_method = :smtp
    #   puts "USING MAILTRAP USERNAME: #{first_inbox['username']} on domain: #{first_inbox['domain']}"
    #   config.action_mailer.smtp_settings = {
    #     :user_name => first_inbox['username'],
    #     :password => first_inbox['password'],
    #     :address => first_inbox['domain'],
    #     :domain => first_inbox['domain'],
    #     :port => first_inbox['smtp_ports'][0],
    #     :authentication => :plain
    #   }
    # end
    
    # MAILGUN
    # if Rails.env.production?
    #   config.action_mailer.smtp_settings = {
    #     :port           => ENV['MAILGUN_SMTP_PORT'],
    #     :address        => ENV['MAILGUN_SMTP_SERVER'],
    #     :user_name      => ENV['MAILGUN_SMTP_LOGIN'],
    #     :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    #     :domain         => host,
    #     :authentication => :plain,
    #   }
    # end
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.default_url_options = { host: host }
    config.database_credentials = {}
    if ENV['BOREALIS_PG_BLUE_SSH_TUNNEL_BPG_CONNECTION_INFO'].present?
      borealis_db_key_value_pairs = ENV['BOREALIS_PG_BLUE_SSH_TUNNEL_BPG_CONNECTION_INFO'].split('|').collect{|v| v.split(':=')}
      borealis_db_key_value_pairs.each do |key, value|
        config.database_credentials[key] = value
      end
    end
  end
end
