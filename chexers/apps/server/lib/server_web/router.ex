defmodule ServerWeb.Router do
  use ServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ServerWeb do
    pipe_through :api

    post "/game", GameController, :create
    get "/game/:id", GameController, :show
    delete "/game/:id", GameController, :delete
  end
end
