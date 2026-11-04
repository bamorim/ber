defmodule BerWeb do
  @moduledoc """
  Entrypoint for the web interface: `use BerWeb, :controller`, `:html`, etc.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt site.webmanifest)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html]

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      import Phoenix.HTML

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: BerWeb.Endpoint,
        router: BerWeb.Router,
        statics: BerWeb.static_paths()
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
