require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaskMonitor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

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

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.perform_deliveries = true
    host = ENV["HOST_DOMAIN"] #replace with your own url
    config.action_mailer.default_url_options = { host: host }
    config.action_mailer.smtp_settings = {
      # :user_name => 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
      # :password => '<SENDGRID_API_KEY>', # This is the secret sendgrid API key which was issued during API key creation
      user_name: ENV["SENDGRID_USERNAME"],
      password: ENV["SENDGRID_PASSWORD"],
      :domain => 'yourdomain.com',
      :address => 'smtp.sendgrid.net',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
    }
  end
end
