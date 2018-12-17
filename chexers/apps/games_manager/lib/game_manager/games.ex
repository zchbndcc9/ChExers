defmodule GameManager.Games do
  use GenServer
  @moduledoc """
  This module servers as the GenServer wrapper to the Game module
  """

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    {_status, game} = Game.new_game()
    {:ok, game}
  end

  def move(pid, player, from, to) do
    GenServer.call(pid, {:move, player, from, to})
  end

  def get_game(pid) do
    GenServer.call(pid, {:get})
  end

  def handle_call({:move, player, from, to}, _pid, game) do
    {status, updated_game} = Game.move(game, player, from, to)
    {:reply, {status, updated_game}, updated_game}
  end

  def handle_call({:get}, _pid, game) do
    {:reply, game, game}
  end
end
