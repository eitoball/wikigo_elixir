alias WikigoElixir.User
alias WikigoElixir.Repo
alias WikigoElixir.Word

case Repo.get(User, 1) do
  nil -> %User{id: 1}
  user -> user
end
|> User.changeset(%{
  email: "wiki@example.com",
  name: "wiki",
  password: "letseditwiki",
  password_confirmation: "letseditwiki"
})
|> Repo.insert_or_update!

case Repo.get(Word, 1) do
  nil -> %Word{id: 1}
  word -> word
end
|> Word.changeset(%{
  title: "_main", body: "ここを編集して開始して下さい。"
})
|> Repo.insert_or_update!

Repo.get_by(Word, title: "_menu") ||
  Repo.insert!(%Word{title: "_menu"})
