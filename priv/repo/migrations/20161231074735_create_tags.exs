defmodule WikigoElixir.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :taggings_count, :integer, default: 0

      timestamps()
    end

    create unique_index(:tags, [:name])

    create table(:taggings) do
      add :context, :string, limit: 128
      add :tag_id, references :tags
      add :taggable_id, :integer
      add :taggable_type, :string
      add :tagger_id, :integer
      add :tagger_type, :string

      timestamps()
    end

    create index(:taggings, [:context])
    create index(:taggings, [:tag_id])
    create index(:taggings, [:taggable_id, :taggable_type, :context])
    create index(:taggings, [:taggable_id, :taggable_type, :tagger_id, :context])
    create index(:taggings, [:taggable_id])
    create index(:taggings, [:taggable_type])
    create index(:taggings, [:tagger_id, :tagger_type])
    create index(:taggings, [:tagger_id])
    create unique_index(:taggings, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type])
  end
end
