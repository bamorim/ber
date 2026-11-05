defmodule BerWeb.PageControllerTest do
  use BerWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    html = conn |> get("/") |> html_response(200)

    for %{name: name} <- Ber.get_links() do
      assert html =~ name
    end

    assert html =~ ~s(href="/blog")
  end

  test "GET /blog lists posts newest first", %{conn: conn} do
    html = conn |> get("/blog") |> html_response(200)

    assert [newest | _] = Ber.Blog.all_posts()
    assert newest.id == "simple-sites-are-amazing"
    assert html =~ ~s(href="/blog/simple-sites-are-amazing")
    assert html =~ "May 25, 2022"
  end

  test "GET /blog/:id renders markdown with highlighted code", %{conn: conn} do
    html = conn |> get("/blog/k8s-dev-cluster-with-kind-and-tailscale") |> html_response(200)

    assert html =~ "<title>K8s dev cluster with Kind and Tailscale · Bernardo Amorim</title>"
    assert html =~ ~s(<h2 id="the-plan">)
    # syntect inlines colors into code blocks
    assert html =~ ~r/<pre[^>]*style="[^"]*background-color/
  end

  test "GET /blog/unknown is a 404", %{conn: conn} do
    assert_error_sent 404, fn -> get(conn, "/blog/nope") end
  end
end
