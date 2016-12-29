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

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: WikigoElixir.User,
  repo: WikigoElixir.Repo,
  module: WikigoElixir,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token]

config :whatwasit,
  repo: WikigoElixir.Repo

config :coherence, WikigoElixir.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine

config :scrivener_html,
  routes_helper: WikigoElixir.Router.Helpers
