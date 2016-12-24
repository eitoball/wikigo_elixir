defmodule WikigoElixir.Repo.Migrations.AddUniqueIndexToTitleOnWords do
  use Ecto.Migration

  def change do
    create unique_index(:words, [:title])
  end
end
