defmodule WikigoElixir.WordControllerTest do
  use WikigoElixir.ConnCase

  alias WikigoElixir.User
  alias WikigoElixir.Word

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} = config do
    if name = config[:login_as] do
      user = User.changeset(%User{}, %{name: name, email: "test@example.com", password: "secret", password_confirmation: "secret"})
      |> Repo.insert!
      {:ok, conn: assign(conn, :current_user, user), user: user}
    else
      :ok
    end
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, word_path(conn, :index)
    assert redirected_to(conn, 301) == word_path(conn, :show, "Main Page")
  end

  @tag login_as: "john"
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, word_path(conn, :new)
    assert html_response(conn, 200) =~ "New word"
  end

  @tag login_as: "john"
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, word_path(conn, :create), word: @valid_attrs
    assert redirected_to(conn, 302) == word_path(conn, :show, @valid_attrs.title)
    assert Repo.get_by(Word, @valid_attrs)
  end

  @tag login_as: "john"
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, word_path(conn, :create), word: @invalid_attrs
    assert html_response(conn, 200) =~ "New word"
  end

  test "shows chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test", body: "Hello, world!"}
    conn = get conn, word_path(conn, :show, word)
    assert html_response(conn, 200) =~ "Hello, world!"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, word_path(conn, :show, -1)
    end
  end

  @tag login_as: "john"
  test "renders form for editing chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test", body: "Hello, world!"}
    conn = get conn, word_path(conn, :edit, word)
    assert html_response(conn, 200) =~ "Hello, world!"
  end

  @tag login_as: "john"
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = put conn, word_path(conn, :update, word), word: @valid_attrs
    word = Repo.get_by(Word, @valid_attrs)
    assert word
    assert redirected_to(conn) == word_path(conn, :show, word)
  end

  @tag login_as: "john"
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    word = Repo.insert! %Word{title: "test"}
    conn = put conn, word_path(conn, :update, word), word: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit word"
  end

  @tag login_as: "john"
  test "deletes chosen resource", %{conn: conn} do
    word = Repo.insert! %Word{title: "test", body: "Hello, world!"}
    conn = delete conn, word_path(conn, :delete, word)
    assert redirected_to(conn) == word_path(conn, :index)
    refute Repo.get(Word, word.id)
  end
end
