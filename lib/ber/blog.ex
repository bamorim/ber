defmodule Ber.Blog do
  @moduledoc """
  Blog posts compiled from `priv/posts/YYYY-MM-DD-some-slug.md`.

  Each file starts with an Elixir map of attributes, then `---`, then markdown:

      %{title: "Hello world"}
      ---
      Body in **markdown**.
  """

  defmodule Post do
    @enforce_keys [:id, :title, :date, :body]
    defstruct [:id, :title, :date, :body]

    def build(filename, attrs, body) do
      <<date::binary-size(10), "-", id::binary>> = Path.basename(filename, ".md")

      struct!(
        __MODULE__,
        [id: id, date: Date.from_iso8601!(date), body: body] ++ Map.to_list(attrs)
      )
    end
  end

  defmodule NotFoundError do
    defexception [:message, plug_status: 404]
  end

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:ber, "priv/posts/*.md"),
    as: :posts,
    comrak_options: [
      extension: [tasklist: true, footnotes: true, header_id_prefix: ""],
      syntax_highlight: [engine: :syntect, opts: [theme: "Catppuccin Macchiato"]]
    ]

  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  def all_posts, do: @posts

  def get_post!(id) do
    Enum.find(all_posts(), &(&1.id == id)) || raise NotFoundError, "post #{inspect(id)} not found"
  end
end
