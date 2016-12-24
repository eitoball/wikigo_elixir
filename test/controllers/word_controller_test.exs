defmodule WikigoElixir.WordControllerTest do
  use WikigoElixir.ConnCase

  alias WikigoElixir.Word
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, word_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing words"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, word_path(conn, :new)
    assert html_response(conn, 200) =~ "New word"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, word_path(conn, :create), word: @valid_attrs
    assert redirected_to(conn) == word_path(conn, :index)
    assert Repo.get_by(Word, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, word_path(conn, :create), word: @invalid_attrs
    assert html_response(conn, 200) =~ "New word"
  end

  test "shows chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = get conn, word_path(conn, :show, word)
    assert html_response(conn, 200) =~ "Show word"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, word_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = get conn, word_path(conn, :edit, word)
    assert html_response(conn, 200) =~ "Edit word"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = put conn, word_path(conn, :update, word), word: @valid_attrs
    word = Repo.get_by(Word, @valid_attrs)
    assert word
    assert redirected_to(conn) == word_path(conn, :show, word)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = put conn, word_path(conn, :update, word), word: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit word"
  end

  test "deletes chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = delete conn, word_path(conn, :delete, word)
    assert redirected_to(conn) == word_path(conn, :index)
    refute Repo.get(Word, word.id)
  end
end
