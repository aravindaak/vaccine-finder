defmodule CowinWeb.Router do
  use CowinWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CowinWeb do
    pipe_through :api

    get "/", RequestController, :index
  end
end
