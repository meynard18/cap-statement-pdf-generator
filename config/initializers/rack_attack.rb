class Rack::Attack
  # Allow 3 free requests per IP per day

  # throttle("limit_generations_per_ip", limit: 1, period: 1.day) do |req|
  #   # Only throttle the AI generation endpoint
  #   if req.path == "/capability_statements" && req.post?
  #     req.ip
  #   end
  # end

  # self.throttled_response = lambda do |_env|
  #   [
  #     429, # HTTP status
  #     { 'Content-Type' => 'application/json' },
  #     [{ error: "Free limit reached. Please purchase to continue." }.to_json]
  #   ]
  # end
end
