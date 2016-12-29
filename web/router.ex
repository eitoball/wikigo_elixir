defmodule WikigoElixir.Router do
  use WikigoElixir.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/-" do
    pipe_through :browser
    coherence_routes
    get "/index", WikigoElixir.WordController, :index, as: "words_index"
  end

  scope "/-" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", WikigoElixir do
    pipe_through :browser # Use the default browser stack

    resources "/", WordController, param: "title", except: [:index]
    get "/:title/version/:version", WordController, :version
  end

  # Other scopes may use custom stacks.
  # scope "/api", WikigoElixir do
  #   pipe_through :api
  # end
end
