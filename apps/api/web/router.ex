defmodule Api.Router do
  use Api.Web, :router

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

  scope "/", Api do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Api do
     pipe_through :api
     get "/", RootController, :index
     get "/register", RegisterController, :index
     post "/register/:session_key", RegisterController, :create
     get "/q1/:session_key", Q1Controller, :index
     post "/q1/:session_key", Q1Controller, :create
     get "/quest2/:session_key", Q2Controller, :index
     post "/quest2/:session_key", Q2Controller, :create
     get "/que3/:session_key", Q3Controller, :index
     post "/que3/:session_key", Q3Controller, :create
   end
end
