defmodule SandwarWeb.PageController do
  use SandwarWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _) do
    LiveView.Controller.live_render(conn, SandwarWeb.HomeView, session: %{})
  end

  def sign_in(conn, _params) do
    render(conn, "index.html")
  end
end
