import Config

config :ber, BerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [formats: [html: BerWeb.ErrorHTML], layout: false],
  pubsub_server: Ber.PubSub

# Precompiled markdown NIF with syntect built in (used by Ber.Blog).
config :mdex_native, syntax_highlighter: :syntect

config :tailwind,
  version: "4.3.4",
  default: [
    args: ~w(--input=assets/css/app.css --output=priv/static/assets/app.css),
    cd: Path.expand("..", __DIR__)
  ]

config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, JSON

import_config "#{config_env()}.exs"
