defmodule SandwarWeb.PageController do
  use SandwarWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
