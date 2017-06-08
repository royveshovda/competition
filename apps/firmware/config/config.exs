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

import_config "#{System.get_env("MIX_TARGET")||'host'}.exs"

# ntpd binary to use
config :nerves_ntp, :ntpd, "/usr/sbin/ntpd"

# servers to sync time from
config :nerves_ntp, :servers, [
    "0.pool.ntp.org",
    "1.pool.ntp.org",
    "2.pool.ntp.org",
    "3.pool.ntp.org"
  ]

# Phoenix
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PIbPfCnw7wecdCV0yldODBCv6ETjVId0wEmJ+pc58pVpkz65nUvGImfgql07/bG3",
  render_errors: [view: Api.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Nerves.PubSub]

  # Import environment specific config. This must remain at the bottom
  # of this file so it overrides the configuration defined above.
import_config "#{System.get_env("MIX_ENV")||'dev'}.exs"

# Import Timber, structured logging
import_config "timber.exs"
