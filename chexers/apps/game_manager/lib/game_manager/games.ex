defmodule GameManager.Games do
  use GenServer
  @moduledoc """
  This module servers as the GenServer wrapper to the Game module
  """

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def init(_) do
    {_status, game} = Game.new_game()
    {:ok, game}
  end

  defp via_tuple(name), do: {:via, Registry, {:game_registry, name}}

  def move(game_name, player, from, to) do
    GenServer.call(via_tuple(game_name), {:move, player, from, to})
  end

  def get_game(name) do
    GenServer.call(via_tuple(name), {:get})
  end

  def handle_call({:move, player, from, to}, _pid, game) do
    {status, updated_game} = Game.move(game, player, from, to)
    {:reply, {status, updated_game}, updated_game}
  end

  def handle_call({:get}, _pid, game) do
    {:reply, game, game}
  end
end
