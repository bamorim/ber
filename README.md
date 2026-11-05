# Ber

Source for [bamorim.com](https://bamorim.com).

    mise install && mix setup && mix phx.server   # http://localhost:4000

## Writing a post

Add `priv/posts/YYYY-MM-DD-some-slug.md` (served at `/blog/some-slug`):

    %{title: "Hello world"}
    ---
    Markdown body. Fenced code blocks get syntax highlighting.

Posts are compiled in by [NimblePublisher](https://hexdocs.pm/nimble_publisher)
(rendered with MDEx's native engine); the dev server live-reloads on save.

## Deploy

    fly deploy
