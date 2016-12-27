# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     WikigoElixir.Repo.insert!(%WikigoElixir.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
WikigoElixir.Repo.get_by(WikigoElixir.Word, title: "_menu") ||
  WikigoElixir.Repo.insert!(%WikigoElixir.Word{title: "_menu"})
