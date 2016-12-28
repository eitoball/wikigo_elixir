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
  password: "password",
  password_confirmation: "password"
})
|> Repo.insert_or_update!

case Repo.get_by(Word, title: "Main Page") do
  nil -> %Word{title: "Main Page", body: "Wiki wiki go!"}
  word -> word
end
|> Word.changeset
|> Repo.insert_or_update!
