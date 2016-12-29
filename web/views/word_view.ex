defmodule WikigoElixir.WordView do
  use WikigoElixir.Web, :view
  import Scrivener.HTML

  def add_word_link(conn, body) do
    WikigoElixir.Word.titles
    |> Enum.reduce(body, fn (title, acc) ->
      show_word_path = word_path(conn, :show, title)
      link = link(title, to: show_word_path) |> safe_to_string
      Regex.replace(~r/#{title}/, acc, link)
    end)
  end

  def versions(word) do
    WikigoElixir.Whatwasit.Version.versions(word)
  end

  def has_version?(word) do
    versions(word) |> Enum.empty? |> Kernel.not
  end
end
