defmodule WikigoElixir.Earmark.HtmlRenderer do
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
    map_func.(blocks, &(render_block(&1, context, map_func)))
    |> IO.iodata_to_binary
  end

  defp render_block(%Block.Heading{level: level, content: content, attrs: attrs}, context, _mf) do
    text = convert(content, context)
    html = "<h#{level}>#{text}</h#{level}>\n"
    id_value = text |> String.downcase |> String.replace(" ", "-")
    attrs = if is_nil(attrs) do
      "id=\"#{id_value}\""
    else
      "id=\"#{id_value}\" #{attrs}"
    end
    add_attrs(html, attrs)
  end

  defp render_block(block, context, mf) do
    Earmark.HtmlRenderer.render_block(block, context, mf)
  end
end
