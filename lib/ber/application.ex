defmodule Ber.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: Ber.PubSub},
      BerWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Ber.Supervisor)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
