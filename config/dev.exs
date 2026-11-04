import Config

config :ber, BerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "A48ulquKNrnJvRX5/kfkYrsTsFLLQKzQMnYGX5C2l3CbmqcBVqBE5K5iNIMF1rSx",
  watchers: [
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/posts/.*md$",
      ~r"lib/ber_web/.*(ex|heex)$"
    ]
  ]

config :logger, :default_formatter, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
