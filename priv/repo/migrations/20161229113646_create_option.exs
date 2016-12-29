defmodule WikigoElixir.Repo.Migrations.CreateOption do
  use Ecto.Migration

  def change do
    create table(:options) do
      add :option_key, :string
      add :option_value, :string

      timestamps()
    end

  end
end
