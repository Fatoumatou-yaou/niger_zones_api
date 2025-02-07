# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ]

      ActiveSupport::Notifications.subscribe("rack.cors") do |_name, _start, _finish, _id, payload|
        origin = payload[:env]["HTTP_ORIGIN"] || "unknown"
        Rails.logger.info("[CORS] API accessed from Origin: #{origin}")
      end
  end
end
