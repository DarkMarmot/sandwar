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

  def handle_event("show_code", _value, socket) do
    {:noreply, assign(socket, editing_code: true)}
  end

  def handle_event("hide_code", _value, socket) do
    {:noreply, assign(socket, editing_code: false)}
  end

  def handle_event("submit_message", value, socket) do
    IO.inspect("message was: #{inspect(value)}")
    msg = get_in(value, ["message", "content"])

    {:noreply,
     update(socket, :messages, fn messages ->
       [msg | Enum.reverse(messages)] |> Enum.take(10) |> Enum.reverse()
     end)}
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
    heading = if ship.speed > 0, do: ship.heading, else: ship.facing

    %{
      hull: render_number(ship.hull, 0),
      energy: render_number(ship.energy, 0),
      speed: render_number(ship.speed, 2),
      heading: heading,
      position: ship.position,
      scanning_radius: ship.scanning_power,
      scanning_power: render_number(ship.scanning_power, 0),
      cloaking_power: render_number(ship.cloaking_power, 0),
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
    :erlang.float_to_binary(number / 1, decimals: digits)
  end

  def terminate(reason, %{} = socket) do
    Warzone.BattleServer.leave()
    reason
  end

  def mount(session, socket) do
    if connected?(socket), do: Warzone.BattleServer.join()

    #    data = %{code_content: "hello", code_error: "cat man"}
    #    types = %{code_content: :string, code_error: :string}
    #    cs = Ecto.Changeset.cast({data, types}, %{code_content: "world", code_error: "hello"}, [:code_content, :code_error])

    current_user = Map.get(session, :current_user)
    user_name = Map.get(session, :user_name)
    login = Map.get(session, :login)
    IO.inspect(session)
    IO.puts("cu #{inspect(current_user)}")

    {:ok,
     assign(socket,
       current_user: current_user,
       user_name: user_name,
       login: login,
       editing_code: false,
       missiles: [],
       ships: [],
       hull: 0,
       energy: 0,
       speed: 0,
       heading: 0,
       cloaking_power: 0,
       scanning_power: 0,
       scanning_radius: 0,
       position: [0, 0],
       code_content: "",
       code_status: ""
     )}
  end
end
