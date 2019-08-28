defmodule SandwarWeb.HomeView do
  use Phoenix.LiveView

  def render(assigns) do
    SandwarWeb.PageView.render("home.html", assigns)
  end

  def handle_event("submit_code", value, socket) do
    code_content = Map.get(value, "code_content")
    Warzone.BattleServer.submit_code(code_content)
    {:noreply, assign(socket, code_content: code_content)}
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
      ships: Map.get(ship.display, :ships, []),
      playing: ship.playing,
      spawn_counter: ship.spawn_counter,
      messages: ship.messages,
      missile_color: ship.missile_color,
      stardate: ship.stardate
    }
  end

  def get_compilation_status_message(status) do
    case status do
      :ai_ready -> "...ai ready, preparing to spawn..."
      :ai_engaged -> "...compilation successful, ai engaged..."
      :ai_timeout_error -> "...ai crawling, timeout error..."
      :ai_runtime_error -> "...system crashing, ai runtime error..."
      :ai_could_not_compile -> "...ai compilation failure..."
      :missing_ai -> "...ai reset, preparing to compile..."
      nil -> "...ai reset, preparing to compile..."
    end
  end

  def render_number(number, digits) do
    :erlang.float_to_binary(number / 1, decimals: digits)
  end

  def terminate(reason, %{} = socket) do
    Warzone.BattleServer.leave()
    reason
  end

  def random_name() do
    "anon_" <> to_string(trunc(:rand.uniform() * 100_000))
  end

  def mount(session, socket) do

    current_user = Map.get(session, :current_user)
    user_name = Map.get(session, :user_name)
    login = Map.get(session, :login, random_name())

    if connected?(socket), do: Warzone.BattleServer.join(login)

    {:ok,
     assign(socket,
       missile_color: 0,
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
       code_status: "",
       playing: false,
       spawn_counter: 30,
       messages: [],
       stardate: 0
     )}
  end
end
