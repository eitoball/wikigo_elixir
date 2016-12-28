defmodule WikigoElixir.Redirector do
  use Plug.Redirect

  redirect "/", "/Main%20Page"
end
