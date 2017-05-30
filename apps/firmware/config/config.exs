# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

config :nerves_interim_wifi,
  regulatory_domain: "NO"

# import_config "#{Mix.Project.config[:target]}.exs"

config :api, :sessions_filename,
  '/root/sessions.dets'
  #'sessions.dets'

  # Import environment specific config. This must remain at the bottom
  # of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Import Timber, structured logging
import_config "timber.exs"
