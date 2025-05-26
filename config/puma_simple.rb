# RAILWAY BYPASS MODE - Simplified Puma configuration
# This configuration completely bypasses potential Railway conflicts

puts "=== RAILWAY BYPASS MODE - Simple Puma Configuration ==="

# CRITICAL: Clear ALL Puma-related environment variables immediately
%w[PUMA_BIND PUMA_BIND_TO PUMA_PORT BIND WEB_CONCURRENCY WORKERS].each do |var|
  if ENV[var]
    puts "Clearing: #{var}=#{ENV[var]}"
    ENV.delete(var)
  end
end

# Clear any variable containing $PORT
ENV.keys.select { |k| ENV[k]&.include?('$PORT') }.each do |key|
  puts "Clearing problematic variable: #{key}=#{ENV[key]}"
  ENV.delete(key)
end

# Basic Puma configuration
threads 15, 15
workers 0
environment ENV.fetch('RAILS_ENV', 'production')

# Super safe port handling
port_string = ENV['PORT'].to_s.strip
port_number = if port_string.empty? || port_string == '$PORT' || !port_string.match?(/\A\d+\z/)
                puts "PORT issue detected: '#{port_string}' - using fallback 8080"
                8080
              else
                port_string.to_i
              end

puts "Final port number: #{port_number}"

# Simple, direct bind - no variables, no interpolation issues
case port_number
when 8080
  bind "tcp://0.0.0.0:8080"
when 3000
  bind "tcp://0.0.0.0:3000"  
when 5000
  bind "tcp://0.0.0.0:5000"
else
  # For any other port, use string concatenation to avoid interpolation issues
  bind_string = "tcp://0.0.0.0:" + port_number.to_s
  bind bind_string
end

# Disable pidfile explicitly
pidfile false

puts "Binding to 0.0.0.0:#{port_number}"
puts "Environment: #{ENV.fetch('RAILS_ENV', 'production')}"
puts "=== Simple Configuration Complete ==="
