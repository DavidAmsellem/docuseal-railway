# Simplified Puma configuration for Railway deployment
# This is a fallback configuration that avoids complex environment variable handling

threads 15, 15
workers 0

# Simple port configuration
port_number = (ENV['PORT'] || '3000').to_i
port_number = 3000 if port_number <= 0

# Always bind to 0.0.0.0 in production for external access
bind "tcp://0.0.0.0:#{port_number}"

environment ENV.fetch('RAILS_ENV', 'production')

# Disable pidfile
@options[:pidfile] = false

# Allow more time for workers in development
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'production') == 'development'

puts "Puma binding to 0.0.0.0:#{port_number} in #{ENV.fetch('RAILS_ENV', 'production')} environment"
