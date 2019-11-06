defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VotingWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/topics", TopicController
    resources "/posts", PostController
    live "/button", Live.Buttons
  end

  # Other scopes may use custom stacks.
  # scope "/api", VotingWeb do
  #   pipe_through :api
  # end
end
