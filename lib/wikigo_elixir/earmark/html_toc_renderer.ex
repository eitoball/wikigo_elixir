defmodule WikigoElixir.Earmark.HtmlTocRenderer do
  alias Earmark.Block
  import Earmark.Inline, only: [convert: 2]

  renderer = Macro.expand(Earmark.HtmlRenderer, __ENV__)
  functions = renderer.__info__(:functions)
  signatures = Enum.map(functions, fn ({ name, arity }) ->
    args = Enum.map(0..arity, fn (i) ->
      { :erlang.binary_to_atom(<< ?x, ?A + i >>, :latin1), [], Elixir }
    end)
    { name, [], tl(args) }
  end)
  defdelegate unquote(signatures), to: Earmark.HtmlRenderer
  defoverridable functions

  def render(blocks, context, map_func) do
    text = map_func.(blocks, &(render_block(&1, context, map_func)))
    |> IO.iodata_to_binary
    "<ul>\n#{text}</ul>"
  end

  defp render_block(%Block.Heading{level: level, content: content, attrs: attrs}, context, _mf) do
    text = convert(content, context)
    id_value = text |> String.downcase |> String.replace(" ", "-")
    "<li><a href=\"##{id_value}\">#{text}</a></li>\n"
  end

  defp render_block(_block, _context, _mf), do: ""
end
