defmodule SandwarWeb.AuthController do
  use SandwarWeb, :controller

  def index(conn, %{"provider" => provider}) do
    redirect(conn, external: authorize_url!(provider))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    user = get_user!(provider, client)

    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/sandwar")
  end

  defp authorize_url!("github"), do: GitHub.authorize_url!()
  defp get_token!("github", code), do: GitHub.get_token!(code: code)

  defp get_user!("github", client) do
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], login: user["login"], avatar: user["avatar_url"]}
  end
end
