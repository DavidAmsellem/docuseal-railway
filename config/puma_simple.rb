# Simplified Puma configuration for Railway deployment
# This configuration avoids complex environment variable handling

threads 15, 15
workers 0

# Clean port configuration - handle Railway's PORT variable
port_string = ENV['PORT'].to_s
port_number = if port_string.empty? || port_string == '$PORT' || !port_string.match?(/\A\d+\z/)
                3000
              else
                port_string.to_i
              end

# Always bind to 0.0.0.0 in production for external access
bind "tcp://0.0.0.0:#{port_number}"

environment ENV.fetch('RAILS_ENV', 'production')

# Disable pidfile
pidfile false

# Allow more time for workers in development
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'production') == 'development'

# Clear any problematic bind configurations
ENV.delete('PUMA_BIND')
ENV.delete('PUMA_BIND_TO')

puts "=== Simplified Puma Configuration ==="
puts "Binding to 0.0.0.0:#{port_number}"
puts "Environment: #{ENV.fetch('RAILS_ENV', 'production')}"
puts "======================================"
