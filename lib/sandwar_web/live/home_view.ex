defmodule SandwarWeb.HomeView do
  use Phoenix.LiveView

  def render(assigns) do
    SandwarWeb.PageView.render("home.html", assigns)
  end

  def handle_event("submit_code", value, socket) do
#    IO.puts("moo")
#    IO.inspect(value)

    code_content = Map.get(value, "code_content")
    Warzone.BattleServer.submit_code(code_content)
    IO.inspect("got stuff: #{inspect(value)}")
    {:noreply, assign(socket, code_content: code_content, deploy_step: "Code...")}
  end

  def handle_event("apply_code", _value, socket) do
    IO.puts("code going in")
    {:noreply, assign(socket, deploy_step: "Load...")}
  end




  def handle_event("submit_cats", _value, socket) do
    {:noreply, assign(socket, deploy_step: "Cats deploy...")}
  end

  def handle_event("eat_cats", _value, socket) do
    {:noreply, assign(socket, deploy_step: "Cats are yummy...")}
  end

  def handle_event("submit_message", value, socket) do
    IO.inspect("message was: #{inspect(value)}")
    msg = get_in(value, ["message", "content"])
    {:noreply, update(socket, :messages, fn messages -> [msg | Enum.reverse(messages)] |> Enum.take(10) |> Enum.reverse() end)}
  end

  def handle_info({:ship_status, ship}, socket) do
    v = inspect(ship.velocity)
#    status = inspect(ship.ai_error)
#    "...compilation sucessful, ai engaged..."

#    display_values =
#    [:speed, :facing, :position]
#    |> Enum.into(%{}, fn k -> {k, Map.get(ship, k)} end)
#    |> Map.put(:code_status, get_compilation_status_message(ship.ai_error))
#    |> Map.to_list()

#    display_values = %{
#      hull: render_number(ship.hull, 0),
#      energy: render_number(ship.hull, 0),
#      speed: render_number(ship.speed, 2),
#      facing: render_number(ship.facing, 2),
#      left: "50%",
#      top: "50%",
#      code_status: get_compilation_status_message(ship.ai_error)
#    }

    {:noreply, assign(socket, get_ship_display(ship))}
  end

  def get_ship_display(ship) do
    %{
      hull: render_number(ship.hull, 0),
      energy: render_number(ship.hull, 0),
      speed: render_number(ship.speed, 2),
      facing: render_number(ship.facing, 2),
      code_status: get_compilation_status_message(ship.ai_error),
      missiles: Map.get(ship.display, :missiles, []),
      ships: Map.get(ship.display, :ships, [])
    }
  end

  def get_compilation_status_message(status) do
    case status do
      nil -> "...compilation sucessful, ai engaged..."
      :ai_timeout_error -> "...ai crawling, timeout error..."
      :ai_runtime_error -> "...system crashing, ai runtime error..."
      :ai_could_not_compile -> "...ai compilation failure..."
      :no_ai -> "...ai cleared, preparing to compile..."
    end
  end

  def render_number(number, digits) do
    :erlang.float_to_binary(number / 1, [decimals: digits])
  end

  def mount(_session, socket) do

    if connected?(socket), do: Warzone.BattleServer.join()

#    data = %{code_content: "hello", code_error: "cat man"}
#    types = %{code_content: :string, code_error: :string}
#    cs = Ecto.Changeset.cast({data, types}, %{code_content: "world", code_error: "hello"}, [:code_content, :code_error])


    {:ok, assign(socket, missiles: [], ships: [], hull: 0, energy: 0, speed: 0, facing: 0, position: [0, 0], code_content: "", code_status: "")}
  end

end