# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :api, Api.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PIbPfCnw7wecdCV0yldODBCv6ETjVId0wEmJ+pc58pVpkz65nUvGImfgql07/bG3",
  render_errors: [view: Api.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Api.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :debug

config :api, :sessions_filename,
  'sessions.dets'

config :api, :questions,
  q1: "What is 1+1?",
  a1: 2,
  q2: "What is 2+2?",
  a2: 4,
  q3: "What is 3+3?",
  a3: 6

config :api, :slack,
  url: "<webhook url>"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Import Timber, structured logging
import_config "timber.exs"
