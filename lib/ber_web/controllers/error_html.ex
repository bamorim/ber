defmodule BerWeb.ErrorHTML do
  use BerWeb, :html

  # "404.html" -> "Not Found"
  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
