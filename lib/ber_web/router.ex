defmodule BerWeb.Router do
  use BerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_root_layout, html: {BerWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  scope "/", BerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/blog", PageController, :blog
    get "/blog/:id", PageController, :post
  end
end
