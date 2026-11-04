defmodule Ber.MixProject do
  use Mix.Project

  def project do
    [
      app: :ber,
      version: "0.1.0",
      elixir: "~> 1.20",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Ber.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.8"},
      {:phoenix_html, "~> 4.4"},
      {:phoenix_live_view, "~> 1.2"},
      {:phoenix_live_reload, "~> 1.7", only: :dev},
      {:bandit, "~> 1.14"},
      {:nimble_publisher, "~> 2.2", runtime: false},
      {:tailwind, "~> 0.5", runtime: Mix.env() == :dev}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "tailwind.install --if-missing"],
      "assets.deploy": ["tailwind default --minify", "phx.digest"]
    ]
  end
end
