# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :wikigo_elixir,
  ecto_repos: [WikigoElixir.Repo]

# Configures the endpoint
config :wikigo_elixir, WikigoElixir.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QG6otfMIJeay4sjiJ8Qn2pXXgYuuZpKKHjvBI0xOrKmh2u3NVq/BDGNPgHHAkXLh",
  render_errors: [view: WikigoElixir.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WikigoElixir.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
