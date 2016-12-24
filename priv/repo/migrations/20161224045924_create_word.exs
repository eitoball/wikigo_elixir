defmodule WikigoElixir.Repo.Migrations.CreateWord do
  use Ecto.Migration

  def change do
    create table(:words) do
      add :title, :string
      add :body, :text

      timestamps()
    end

  end
end
