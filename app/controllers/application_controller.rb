class ApplicationController < ActionController::API
    before_action :log_request_details
    include Pagy::Backend

    private

    def log_request_details
        origin = request.headers['Origin'] || 'unknown'
        ip_address = request.remote_ip
        user_agent = request.headers['User-Agent'] || 'unknown'
        endpoint = "#{request.method} #{request.path}"
        
        Rails.logger.info("[API Request] Origin: #{origin}, IP: #{ip_address}, Endpoint: #{endpoint}, User-Agent: #{user_agent}")
    end
end
