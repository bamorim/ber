import Config

config :ber, BerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZflSFQrP6R7awocad+FUYSuSq9PTVgXrXQFkf05eh3rpbw6G48EY+aHQKxHH2ATc",
  server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
