defmodule GameMatcher.WaitingRoom do
  use GenServer
  @me GameMatcher.WaitingRoom.API

  def start_link(_arg) do
    GenServer.start_link(@me, [], name: @me)
  end

  def init(_args) do
    {:ok, nil}
  end

  def put_in_room(player, game_name) do
    GenServer.call(@me, {:put_in, player, game_name})
  end

  def game_exists?(game_name) do
    GenServer.call(@me, {:exists?, game_name})
  end

  def remove_game(game_name) do
    GenServer.call(@me, {:remove, game_name})
  end

  def get_room() do
    GenServer.call(@me, {:get})
  end
end
