defmodule WikigoElixir.Tag do
  use Ecto.Schema
  import Ecto
  import Ecto.Changeset
  require Ecto.Query
  import Ecto.Query

  schema "tags" do
    field :name, :string
    field :taggings_count, :integer
    has_many :taggings, WikigoElixir.Tagging

    timestamps()
  end

  def changeset(struct, params \\ %{}, opts \\ []) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def list(schema) do
    id = schema.id
    type = schema.__struct__ |> Atom.to_string
    from(t in WikigoElixir.Tag,
     select: t.name,
     inner_join: g in assoc(t, :taggings),
     where: g.taggable_type == ^type and g.taggable_id == ^id
    ) |> WikigoElixir.Repo.all
  end

  def counts(type) do
    from(t in WikigoElixir.Tag,
     select: {t.name, t.taggings_count},
     inner_join: g in subquery(taggings_for(type)),
     order_by: [asc: t.name],
     distinct: true
    ) |> WikigoElixir.Repo.all
  end

  def add(schema, name) do
    id = schema.id
    type = schema.__struct__ |> Atom.to_string
    queryable = from(t in WikigoElixir.Tag,
     select: t.name,
     inner_join: g in assoc(t, :taggings),
     where: g.taggable_type == ^type and g.taggable_id == ^id and t.name == ^name
    )
    case WikigoElixir.Repo.get_by(queryable, []) do
    nil ->
      case WikigoElixir.Repo.get_by(WikigoElixir.Tag, name: name) do
      nil ->
        %WikigoElixir.Tag{name: name, taggings_count: 1}
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:taggings, [WikigoElixir.Tagging.changeset(%WikigoElixir.Tagging{taggable_id: id, taggable_type: type})])
        |> WikigoElixir.Repo.insert!
      tag ->
        WikigoElixir.Repo.transaction(fn ->
          WikigoElixir.Tagging.changeset(%WikigoElixir.Tagging{tag_id: tag.id, taggable_id: id, taggable_type: type}) |> WikigoElixir.Repo.insert!
          tag |> Ecto.Changeset.cast(%{taggings_count: tag.taggings_count + 1}, [:name, :taggings_count]) |> WikigoElixir.Repo.update
        end)
      end
    tag -> tag
    end
  end

  def update(schema, tags) do
    tags
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&(add(schema, &1)))
  end

  def tagged_with(tag) do
    tag = WikigoElixir.Repo.get_by!(WikigoElixir.Tag, name: tag)
    |> WikigoElixir.Repo.preload(:taggings)
    tag.taggings
    |> Enum.map(fn (tagging) ->
      tagging.taggable_type
      |> String.to_atom
      |> WikigoElixir.Repo.get(tagging.taggable_id)
    end)
  end

  def least_used(type, limit \\ 20) do
    from(t in WikigoElixir.Tag,
     inner_join: g in subquery(taggings_for(type)),
     order_by: [asc: t.taggings_count, asc: t.name],
     distinct: true,
     limit: ^limit
    ) |> WikigoElixir.Repo.all
  end

  def taggings_for(type) do
    Ecto.Query.from(g in WikigoElixir.Tagging,
      select: %{id: g.tag_id},
      where: g.taggable_type == ^Atom.to_string(type)
    )
  end

  def repo, do: WikigoElixir.Repo
end
