defmodule WikigoElixir.Redirector do
  def init(opts), do: opts

  def call(%Plug.Conn{path_info: [], method: "GET"} = conn, _opts) do
    conn
    |> Plug.Conn.put_resp_header("location", WikigoElixir.Router.Helpers.word_path(conn, :show, "Main Page"))
    |> Plug.Conn.resp(301, "You are being redirected.")
    |> Plug.Conn.halt
  end

  def call(conn, _opts), do: conn
end
