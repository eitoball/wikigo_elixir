defmodule WikigoElixir.WordRepoTest do
  use WikigoElixir.ModelCase

  alias WikigoElixir.Word

  test "titles returns empty when no word" do
    assert Word.titles == []
  end

  test "titles lists all titles" do
    [
      %{title: "Home", body: "This is Home"},
      %{title: "WikiGo開発", body: "開発している"}
    ] |> Enum.each(fn (params) ->
      Word.changeset(%Word{}, params) |> Repo.insert!
    end)

    assert "Home" in Word.titles
    assert "WikiGo開発" in Word.titles
  end
end
