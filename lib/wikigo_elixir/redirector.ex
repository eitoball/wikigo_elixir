defmodule WikigoElixir.Redirector do
  use Plug.Redirect

  redirect "/", "/_main"
end
