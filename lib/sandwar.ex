defmodule Sandwar do
  @moduledoc """
  Sandwar keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def render_number(number, digits) do
    :erlang.float_to_binary(number / 1, [decimals: digits])
  end

  def render_position([x, y], digits) do
    "[ " <> render_number(x, digits) <> ", " <> render_number(y, digits) <> " ]"
  end


end
