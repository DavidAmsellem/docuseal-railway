# Railway.app specific configuration for DocuSeal
# This file ensures proper Puma configuration for Railway deployment

# Override any problematic environment variables
ENV.delete('PUMA_BIND') if ENV['PUMA_BIND']&.include?('$')

# Ensure RAILS_ENV is set
ENV['RAILS_ENV'] ||= 'production'

# Debug output for Railway logs
if ENV['RAILWAY_ENVIRONMENT'] || ENV['RAILWAY_DEBUG']
  puts "=== Railway Deployment Configuration ==="
  puts "RAILS_ENV: #{ENV['RAILS_ENV']}"
  puts "PORT: #{ENV['PORT'].inspect}"
  puts "RAILWAY_ENVIRONMENT: #{ENV['RAILWAY_ENVIRONMENT']}"
  puts "USE_SIMPLE_PUMA: #{ENV['USE_SIMPLE_PUMA']}"
  puts "DATABASE_URL: #{ENV['DATABASE_URL'] ? '[SET]' : '[NOT SET]'}"
  puts "SECRET_KEY_BASE: #{ENV['SECRET_KEY_BASE'] ? '[SET]' : '[NOT SET]'}"
  puts "======================================"
end

# Set default PORT if not provided or problematic
if ENV['PORT'].nil? || ENV['PORT'] == '$PORT' || !ENV['PORT'].match?(/\A\d+\z/)
  puts "WARNING: PORT not set correctly, using 3000"
  ENV['PORT'] = '3000'
end
