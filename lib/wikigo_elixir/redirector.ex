defmodule WikigoElixir.Redirector do
  use Plug.Redirect

  redirect "/", "/wiki/_main"
end
