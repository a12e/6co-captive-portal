# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pwc,
  ecto_repos: [Pwc.Repo]

# Configures the endpoint
config :pwc, Pwc.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VgpTPnfvKFqXnYoUe+O85CMbuUZItwYPdb8d15ADA6cEKbl39A68Je80MvA5yMis",
  render_errors: [view: Pwc.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pwc.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :pwc, Pwc.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Watch static and templates for browser reloading.
config :pwc, Pwc.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :pwc, Pwc.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pwc",
  password: "dNhfN5uE5WPEXt5a",
  database: "pwc",
  hostname: "localhost",
  pool_size: 10

