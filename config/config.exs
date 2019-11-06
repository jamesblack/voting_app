# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :voting,
  ecto_repos: [Voting.Repo]

# Configures the endpoint
config :voting, VotingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ml8T+2KNksMDXNmQNmMTqi+i5UbHz31bwaQnWTbZe8C3bd3TRB8Ue+JoSCG2Dujc",
  render_errors: [view: VotingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Voting.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Nwwlm3lrsrFZiwhag6HM5N0geoGXx41y"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
