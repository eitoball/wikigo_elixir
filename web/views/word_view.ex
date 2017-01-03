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

  def tag_cloud([], _classes, _func), do: ""
  def tag_cloud(tags, classes, func) do
    {_, maximum_counts} = Enum.max_by(tags, fn ({_, taggings_count}) -> taggings_count end)
    index_func = fn (c) -> Enum.at(classes, div(c, maximum_counts) * (length(classes) - 1)) end
    Enum.map(tags, fn {name, taggings_count} ->
      func.({name, index_func.(taggings_count)})
    end)
  end
end
