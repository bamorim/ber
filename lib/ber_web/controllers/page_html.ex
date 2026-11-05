defmodule BerWeb.PageHTML do
  use BerWeb, :html

  embed_templates "page_html/*"

  def format_date(date), do: Calendar.strftime(date, "%B %-d, %Y")
end
