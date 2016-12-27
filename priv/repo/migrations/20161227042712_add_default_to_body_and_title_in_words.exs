defmodule WikigoElixir.Repo.Migrations.AddDefaultToBodyAndTitleInWords do
  use Ecto.Migration

  def change do
    alter table(:words) do
      modify :body, :text, default: ""
      modify :title, :string, default: ""
    end
  end
end
