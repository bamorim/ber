defmodule Ber do
  @moduledoc """
  For now I'm keeping all the functions in this module instead of going the
  traditional "contexts" route because this app is really simple now.
  """

  @type link() :: %{
          name: String.t(),
          url: String.t(),
          icon: String.t()
        }

  @spec get_links() :: [link()]
  def get_links do
    [
      %{
        name: "GitHub",
        url: "https://github.com/bamorim/",
        icon: "github"
      },
      %{
        name: "LinkedIn",
        url: "https://www.linkedin.com/in/bdornellas/",
        icon: "linkedin"
      },
      %{
        name: "Twitter",
        url: "https://twitter.com/BernardoDCGA/",
        icon: "twitter"
      },
      %{
        name: "YouTube",
        url: "https://www.youtube.com/@BernardoBits",
        icon: "youtube"
      },
      %{
        name: "Telegram",
        url: "https://t.me/BernardoDCGA",
        icon: "telegram"
      },
      %{
        name: "Blog",
        url: "https://listed.to/@bamorim"
      }
    ]
    |> Enum.map(&Map.put_new(&1, :icon, "external-link"))
  end
end
