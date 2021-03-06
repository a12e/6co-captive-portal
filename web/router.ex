defmodule Pwc.Router do
  use Pwc.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pwc.FetchPeerInfo
  end

  pipeline :admin do
    plug Pwc.AdminFirewall
  end

  scope "/", Pwc do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/login", AuthenticationController, :show
    post "/login", AuthenticationController, :login
    get "/logout", AuthenticationController, :logout

    scope "/admin" do
      pipe_through :admin

      get "/neighbors", NeighborController, :index
      resources "/users", UserController
    end
  end
end
