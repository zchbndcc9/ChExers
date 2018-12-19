defmodule GameMatcher.WaitingRoom.API do
  use GenServer
  alias GameMatcher.WaitingRoom.Impl

  def handle_call({:put_in, player, game_name}, _from, room) do
    {status, new_room} = Impl.put_in(room, player, game_name)

    {:reply, {status, new_room}, new_room}
  end

  def handle_call({:exists?, game_name}, _from, room) do
    {:reply, Impl.exists?(room, game_name), room}
  end

  def handle_call({:remove, game_name}, _, room) do
    {status, return, room} = Impl.remove(room, game_name)

    {:reply, {status, return}, room}
  end

  def handle_call({:get}, _from, room) do
    {:reply, room, room}
  end
end
