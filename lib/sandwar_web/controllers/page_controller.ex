defmodule SandwarWeb.PageController do
  use SandwarWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _) do
    if conn.assigns.current_user do
      LiveView.Controller.live_render(conn, SandwarWeb.HomeView, session: %{})
    else
      render(conn, "index.html")
    end
  end

  def sign_in(conn, _params) do
    render(conn, "index.html")
  end
end
