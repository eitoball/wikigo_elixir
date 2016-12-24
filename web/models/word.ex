defmodule WikigoElixir.Word do
  use WikigoElixir.Web, :model

  schema "words" do
    field :title, :string
    field :body, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :body])
    |> validate_required([:title, :body])
    |> unique_constraint(:title)
  end

  def titles do
    WikigoElixir.Repo.all(from w in WikigoElixir.Word, select: w.title)
  end
end

defimpl Phoenix.Param, for: WikigoElixir.Word do
  def to_param(%{title: title}) do
    title
  end
end
