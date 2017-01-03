defmodule WikigoElixir.Word do
  use WikigoElixir.Web, :model
  use Whatwasit

  schema "words" do
    field :title, :string
    field :body, :string
    field :tags, :string, virtual: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}, opts \\ []) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
    |> unique_constraint(:title)
    |> prepare_version(opts)
  end

  def titles do
    WikigoElixir.Repo.all(from w in WikigoElixir.Word, select: w.title)
  end

  def recents do
    WikigoElixir.Repo.all(from w in WikigoElixir.Word, limit: 5, order_by: [desc: w.inserted_at])
  end
end

defimpl Phoenix.Param, for: WikigoElixir.Word do
  def to_param(%{title: title}) do
    title |> String.replace(" ", "-")
  end
end
