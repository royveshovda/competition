use Mix.Config

config :api, Api.Endpoint,
  http: [port: 8200],
  url: [port: 8200],
  cache_static_manifest: "priv/static/manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :phoenix, :serve_endpoints, true

# Finally import the config/prod.secret.exs
# which should be versioned separately.
import_config "prod.secret.exs"
