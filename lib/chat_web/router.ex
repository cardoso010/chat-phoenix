defmodule ChatWeb.Router do
  use ChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug Chat.Accounts.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", ChatWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/login", AuthController, :new
    post "/login", AuthController, :login
    get "/logout", AuthController, :logout
    get "/users/new", UserController, :new
    post "/users", UserController, :create
  end

  scope "/", ChatWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/users", UserController, except: [:new, :create]
    resources "/chats", ChatController
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatWeb do
  #   pipe_through :api
  # end
end
