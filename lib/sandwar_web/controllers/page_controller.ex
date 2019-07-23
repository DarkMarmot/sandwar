defmodule SandwarWeb.PageController do
  use SandwarWeb, :controller

  def index(conn, _params) do
    IO.inspect("conn")
    IO.inspect(conn)

    render(conn, "index.html")
  end
end
