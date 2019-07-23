defmodule SandwarWeb.Live.SandwarView do
  use Phoenix.LiveView

  def render(assigns) do
    SandwarWeb.PageView.render("sandwar.html", assigns)
  end

  def mount(session, socket) do
    if(connected?(socket), do: :timer.send_interval(100, self(), :tick))

    player_id = "p_#{:rand.uniform(10_000_000_000)}"

    socket =
      socket
      |> assign(
        counter: 0,
        player_id: player_id,
        player_info: nil
      )

      IO.inspect("session")
      IO.inspect(session)
    IO.inspect("socket")
    IO.inspect(socket)
    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    {:noreply, update_game_info(socket)}
  end

  def update_game_info(socket) do
    counter = socket.assigns.counter
    socket
    |> assign(:counter, counter + 1)
  end

  def handle_event("create_trivia", value, socket) do
#    player_name = socket.assigns.player_name
#    game = Game.new(%{name: value, player: Player.new(player_name)})
#    {:ok, game_pid} = Trivia.DynamicSupervisor.start_child(game)
#    GameServer.start_game(game_pid)
#    {:noreply, assign_game(socket, game_pid)}
  end

  def handle_event("join_trivia", value, socket) do
#    game_pid = Map.get(socket.assigns.available_trivias, String.to_integer(value))
#    player_name = socket.assigns.player_name
#    GameServer.add_player(game_pid, %Player{Player.new(player_name) | waiting_response: true})
#    {:noreply, assign_game(socket, game_pid)}
  end

  def handle_event("submit_answer", value, socket) do
#    game_pid = socket.assigns.process
#    player_name = socket.assigns.player_name
#
#    socket =
#      if is_pid(game_pid) and Process.alive?(game_pid) do
#        socket
#        |> update(:trivia, fn _trivia ->
#          GameServer.submit_answer(game_pid, player_name, value)
#          GameServer.game(game_pid)
#        end)
#        |> player_info()
#      else
#        socket
#      end
#
#    {:noreply, socket}
  end

#  def assign_game(socket, game_pid) do
#    socket
#    |> assign(:trivia, GameServer.game(game_pid))
#    |> assign(:process, game_pid)
#    |> player_info()
#  end
#
#  def clean_game(socket) do
#    socket
#    |> assign(:trivia, nil)
#    |> assign(:process, nil)
#    |> assign(:player_info, nil)
#    |> trivias()
#  end

  def trivias(socket) do
#    childs = DynamicSupervisor.which_children(Trivia.DynamicSupervisor)
#
#    available_trivias =
#      childs
#      |> Enum.with_index()
#      |> Enum.map(fn {value, index} ->
#        {_, pid, _, _} = value
#        game = GameServer.game(pid)
#
#        case game.status do
#          "waiting" -> {index, pid}
#          _ -> {index, nil}
#        end
#      end)
#      |> Enum.filter(fn {_index, pid} -> pid != nil end)
#      |> Map.new()
#
#    socket
#    |> assign(:number_of_trivias, Enum.count(childs))
#    |> assign(:number_of_available_trivias, Enum.count(available_trivias))
#    |> assign(:available_trivias, available_trivias)
  end

  defp player_info(socket) do
#    player_name = socket.assigns.player_name
#    player_info = Enum.find(socket.assigns.trivia.players, &(&1.name == player_name))
#    assign(socket, :player_info, player_info)
  end
end


