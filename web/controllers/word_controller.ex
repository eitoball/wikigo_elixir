defmodule WikigoElixir.WordController do
  use WikigoElixir.Web, :controller

  plug Coherence.Authentication.Session, [protected: true] when action in [:create, :update, :new, :edit, :delete, :version]
  plug :convert_title_param

  alias WikigoElixir.Word

  def index(conn, params) do
    words = Word |> Repo.paginate(params)
    render(conn, "index.html", words: words)
  end

  def new(conn, _params) do
    changeset = Word.changeset(%Word{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"word" => word_params}) do
    changeset = Word.changeset(%Word{}, word_params)

    case Repo.insert(changeset) do
      {:ok, word} ->
        conn
        |> put_flash(:info, "Word created successfully.")
        |> redirect(to: word_path(conn, :show, word))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"title" => title}) do
    word = Repo.get_by!(Word, title: title)
    word = %Word{ word | tags: word |> WikigoElixir.Tag.list |> Enum.sort |> Enum.join(",") }
    render(conn, "show.html", word: word)
  end

  def edit(conn, %{"title" => title}) do
    word = Repo.get_by!(Word, title: title)
    word = %Word{ word | tags: word |> WikigoElixir.Tag.list |> Enum.sort |> Enum.join(",") }
    changeset = Word.changeset(word)
    render(conn, "edit.html", word: word, changeset: changeset)
  end

  def update(conn, %{"title" => title, "word" => word_params}) do
    word = Repo.get_by!(Word, title: title)
    changeset = Word.changeset(word, word_params, whodoneit(conn))

    case Repo.update(changeset) do
      {:ok, word} ->
        tags = Map.get(word_params, "tags", "")
        WikigoElixir.Tag.update(word, tags)
        conn
        |> put_flash(:info, "Word updated successfully.")
        |> redirect(to: word_path(conn, :show, word))
      {:error, changeset} ->
        render(conn, "edit.html", word: word, changeset: changeset)
    end
  end

  def delete(conn, %{"title" => title}) do
    changeset = Repo.get_by!(Word, title: title)
      |> Word.changeset(%{}, whodoneit(conn))

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(changeset)

    conn
    |> put_flash(:info, "Word deleted successfully.")
    |> redirect(to: words_index_path(conn, :index))
  end

  def version(conn, %{"title" => title, "version" => version}) do
    case Repo.get_by!(Word, title: title) do
      nil ->
        conn |> put_status(404) |> render(WikigoElixir.ErrorView, :"404")
      word ->
        case WikigoElixir.Whatwasit.Version.versions(word) |> Enum.at(String.to_integer(version)) do
          nil ->
            conn |> put_status(404) |> render(WikigoElixir.ErrorView, :"404")
          version ->
            render(conn, "show.html", word: version)
        end
    end
  end

  def tags(conn, _params) do
    tags = WikigoElixir.Tag.counts(Word)
    render(conn, "tags.html", tags: tags)
  end

  def tag(conn, %{"tag" => tag}) do
    tag = %{
      name: tag,
      words: WikigoElixir.Tag.tagged_with(tag)
    }
    render(conn, :tag, tag: tag)
  end

  defp whodoneit(conn) do
    user = Coherence.current_user(conn)
    [whodoneit: user, whodoneit_name: user.name]
  end

  def convert_title_param(%Plug.Conn{params: %{"title" => title}} = conn, _opts) do
    params = %{conn.params | "title" => title |> String.replace("-", " ")}
    %{conn | params: params}
  end
  def convert_title_param(conn, _opts), do: conn
end
