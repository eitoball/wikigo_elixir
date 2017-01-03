defmodule WikigoElixir.Tagging do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  require Ecto.Query

  schema "taggings" do
    field :context, :string
    # add :context, :string, limit: 128
    belongs_to :tag, WikigoElixir.Tag
    field :taggable_id, :integer
    field :taggable_type, :string
      # add :tag_id, references :tags
      # add :taggable_id, :integer
      # add :taggable_type, :string
      # add :tagger_id, :integer
      # add :tagger_type, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}, opts \\ []) do
    struct
    # |> cast(params, [:title, :body])
    # |> validate_required([:title, :body])
    # |> unique_constraint(:title)
    # |> prepare_version(opts)
  end
end
