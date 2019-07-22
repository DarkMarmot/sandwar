# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :sandwar, SandwarWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4tQFFkI7bJIcInQLf5S8G79w0N9DCC6F1D2WehZSCPPN4vkUotvXs73PAmR884+j",
  render_errors: [view: SandwarWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sandwar.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
