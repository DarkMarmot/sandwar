defmodule SandwarWeb.PageController do
  use SandwarWeb, :controller

  alias Phoenix.LiveView

  def index(conn, _) do
    if conn.assigns.current_user do
      LiveView.Controller.live_render(conn, SandwarWeb.HomeView,
        session: %{current_user: :current_user}
      )
    else
      render(conn, "index.html")
    end
  end

  def anon(conn, _) do
    LiveView.Controller.live_render(conn, SandwarWeb.HomeView,
      session: %{current_user: :current_user}
    )
  end

  def sign_in(conn, _params) do
    render(conn, "index.html")
  end
end
