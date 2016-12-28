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

case Repo.get_by(Word, title: "_main") do
  nil -> %Word{title: "_main", body: "ここを編集して開始して下さい。"}
  word -> word
end
|> Word.changeset
|> Repo.insert_or_update!
