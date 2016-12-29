defmodule WikigoElixir.Option do
  use WikigoElixir.Web, :model

  schema "options" do
    field :option_key, :string
    field :option_value, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:option_key, :option_value])
    |> validate_required([:option_key, :option_value])
  end
end
