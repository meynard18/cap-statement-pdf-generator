module CapabilityStatementsHelper
  def current_generation_count
    ip_key = "ip:#{request.remote_ip}:generations"
    Rails.cache.read(ip_key).to_i
  end
end
