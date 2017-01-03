defmodule WikigoElixir.TagRepoTest do
  use WikigoElixir.ModelCase

  alias WikigoElixir.Tag
  alias WikigoElixir.Word

  test "" do
    t = %WikigoElixir.Tag{name: "cooking"} |> WikigoElixir.Repo.insert!
    tag = %WikigoElixir.Tag{name: "tech"} |> WikigoElixir.Repo.insert!

    word = %WikigoElixir.Word{title: "title", body: "body"} |> WikigoElixir.Repo.insert!

    %WikigoElixir.Tagging{tag_id: tag.id, taggable_id: word.id, taggable_type: Atom.to_string(word.__struct__)} |> WikigoElixir.Repo.insert!

    w = %WikigoElixir.Word{title: "_t_", body: "_b_"} |> WikigoElixir.Repo.insert!
    %WikigoElixir.Tagging{tag_id: t.id, taggable_id: w.id, taggable_type: Atom.to_string(w.__struct__)} |> WikigoElixir.Repo.insert!

    assert Tag.list(word) == ["tech"]
  end

  test "add new tag" do
    word = %WikigoElixir.Word{title: "title", body: "body"} |> WikigoElixir.Repo.insert!
    tag = Tag.add(word, "tag")
    assert Tag.list(word) == ["tag"]
  end

  test "add more tag" do
    word = %WikigoElixir.Word{title: "title", body: "body"} |> WikigoElixir.Repo.insert!
    Tag.add(word, "tag")
    Tag.add(word, "another tag")
    assert Tag.list(word) |> Enum.sort == ["another tag", "tag"]
  end

  test "counts when empty" do
    assert Tag.counts(WikigoElixir.Word) == []
  end

  test "counts with one tag" do
    %WikigoElixir.Word{title: "title1", body: "body1"} |> WikigoElixir.Repo.insert! |> Tag.add("tag")
    assert Tag.counts(WikigoElixir.Word) == [{"tag", 1}]
    %WikigoElixir.Word{title: "title2", body: "body2"} |> WikigoElixir.Repo.insert! |> Tag.add("tag")
    assert Tag.counts(WikigoElixir.Word) == [{"tag", 2}]
  end

  test "update one tag" do
    word = %WikigoElixir.Word{title: "title1", body: "body1"} |> WikigoElixir.Repo.insert!
    Tag.update(word, "tag1,tag2") |> Enum.map()
    assert Tag.list(word) |> Enum.sort == ["tag1", "tag2"]
  end

  # test "titles lists all titles" do
    # [
      # %{title: "Home", body: "This is Home"},
      # %{title: "WikiGo開発", body: "開発している"}
    # ] |> Enum.each(fn (params) ->
      # Word.changeset(%Word{}, params) |> Repo.insert!
    # end)

    # assert "Home" in Word.titles
    # assert "WikiGo開発" in Word.titles
  # end
end
