class Rack::Attack
    # Throttle requests by IP address: maximum 50 requests per minute
    throttle("req/ip", limit: 50, period: 1.minute) do |req|
      req.ip
    end

    # Safelist local IPs (e.g., during development)
    safelist("allow-localhost") do |req|
      [ "127.0.0.1", "::1" ].include?(req.ip)
    end

    # Blocklist certain IPs (e.g., malicious users or known spammers)
    # blocklist('block-bad-ips') do |req|
    # Replace with IPs you want to block
    #   ['192.168.0.1', '10.0.0.1'].include?(req.ip)
    # end

    # Custom response for blocked requests
    Rack::Attack.blocklisted_responder = lambda do |request|
      # Personnalisez la réponse ici
      [ 403, { "Content-Type" => "text/html" }, [ "<html><body><h1>Accès interdit</h1></body></html>" ] ]
    end

    # Log throttled requests
    ActiveSupport::Notifications.subscribe("rack.attack") do |_name, _start, _finish, _request_id, payload|
      req = payload[:request]
      Rails.logger.info("[Rack::Attack] Throttled request: #{req.ip}") if req.env["rack.attack.match_type"] == :throttle
    end
end
