alias WikigoElixir.User
alias WikigoElixir.Repo
alias WikigoElixir.Word

unless Repo.get(User, 1) do
  User.changeset(%User{}, %{
    id: 1,
    email: "wiki@example.com",
    name: "wiki",
    password: "letseditwiki",
    password_confirmation: "letseditwiki"
  }) |> Repo.insert!
end

[
 %{title: "_main", body: "ここを編集して開始して下さい。"},
 %{title: "_menu", body: ""}
] |> Enum.each(fn (params) ->
  unless Repo.get_by(Word, title: params[:title]) do
    Word.changeset(%Word{}, params) |> Repo.insert!
  end
end)
