#defmodule  SandwarWeb.Live.FormView do
#  use Phoenix.LiveView
#  use Phoenix.HTML
#
#  def render(assigns) do
#    ~L"""
#    <form phx-change="parse" style="display: inline;">
#      <input style="float: left;" type="text" name="dude" value="<%= @dude %>" placeholder="Regex..." />
#      <input style="float: right;" type="text" name="code" value="<%= @code %>" placeholder="Input..." />
#    </form>
#    <%= Phoenix.HTML.raw @result %>
#    """
#  end
#
#  def mount(_session, socket) do
#    {:ok, assign(socket, dude: nil, code: nil, result: "")}
#  end
#
#  def handle_event("parse", %{"dude" => dude, "code" => code} = q, socket) do
#    case Regex.compile(regex) do
#      {:ok, compiled} ->
#        result =
#          Regex.replace(compiled, input, "<span style=\"background-color: #FFFF00\">\\0</span>")
#
#        {:noreply, assign(socket, regex: regex, input: input, result: result)}
#
#      _ ->
#        {:noreply, socket}
#    end
#  end
#end
#
## https://elixirforum.com/t/calling-some-js-code-upon-a-liveview-update/23077/3
