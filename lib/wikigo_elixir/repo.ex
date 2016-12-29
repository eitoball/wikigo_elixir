defmodule WikigoElixir.Repo do
  use Ecto.Repo, otp_app: :wikigo_elixir
  use Scrivener, page_size: 10
end
