# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.

require_relative 'dotenv'

# Always load Railway-specific configuration in production
require_relative 'railway' if ENV['RAILS_ENV'] == 'production'

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 15)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
threads min_threads_count, max_threads_count

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if ENV.fetch('RAILS_ENV', 'development') == 'development'

# Specifies the binding address and port for Puma
# This configuration handles deployment platforms like Railway, Heroku, etc.
port_env = ENV['PORT']

# Validate and clean the PORT environment variable
if port_env && port_env != '$PORT' && port_env.match?(/\A\d+\z/)
  app_port = port_env.to_i
else
  app_port = 3000
end

# For production environments, bind to 0.0.0.0 to accept external connections
if ENV['RAILS_ENV'] == 'production'
  bind "tcp://0.0.0.0:#{app_port}"
else
  port app_port
end

# Specifies the `environment` that Puma will run in.
#
environment ENV.fetch('RAILS_ENV', 'development')

# Specifies the `pidfile` that Puma will use.
@options[:pidfile] = false

# Specifies the number of `workers` to boot in clustered mode.
# Workers are forked web server processes. If using threads and workers together
# the concurrency of the application would be max `threads` * `workers`.
# Workers do not work on JRuby or Windows (both of which do not support
# processes).

if ENV['WEB_CONCURRENCY_AUTO'] == 'true'
  require 'etc'

  workers Etc.nprocessors
else
  workers ENV.fetch('WEB_CONCURRENCY', 0)
end

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory.
#
# preload_app!

if ENV['MULTITENANT'] != 'true' || ENV['DEMO'] == 'true'
  require_relative '../lib/puma/plugin/redis_server'
  require_relative '../lib/puma/plugin/sidekiq_embed'

  plugin :sidekiq_embed
  plugin :redis_server
end
