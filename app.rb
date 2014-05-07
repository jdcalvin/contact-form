require "rubygems"
require "sinatra"
require "pony"

require_relative "config/delivery_config"

# Configuration
DELIVERY_CONFIG = DeliveryConfig.new(ENV)
Pony.options = DELIVERY_CONFIG.pony_options

class App < Sinatra::Application
  get "/" do
    "Contact form is up\n"
  end

  post "/" do
    email = params[:email]
    subject = "Contact form submission"
    @content = params.map do |key, value|
      "#{key}: #{value}"
    end.join("\n")
    puts "Sending:", @content
    puts "Referer: #{request.referer}"
    puts "Pony config: #{Pony.options.inspect}"

    Pony.mail(
      to: DELIVERY_CONFIG.recipient,
      from: DELIVERY_CONFIG.sender,
      subject: subject,
      body: erb[:email]
    )

    redirect DELIVERY_CONFIG.redirect || request.referrer
  end
end