defmodule BerWeb.PageController do
  use BerWeb, :controller

  def index(conn, _params) do
    render(conn, :index, links: Ber.get_links())
  end

  def blog(conn, _params) do
    render(conn, :blog, posts: Ber.Blog.all_posts(), page_title: "Blog")
  end

  def post(conn, %{"id" => id}) do
    post = Ber.Blog.get_post!(id)
    render(conn, :post, post: post, page_title: post.title)
  end
end
