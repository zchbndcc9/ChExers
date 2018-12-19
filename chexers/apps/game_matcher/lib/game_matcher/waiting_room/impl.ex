defmodule GameMatcher.WaitingRoom.Impl do
  defstruct room: %{}

  def put_in(room, player, game_name) do
    new_room =
      room
      |> exists?(game_name)
      |> Map.put_new(game_name, player)

    {:ok, new_room}
  end

  def exists?(room, game_name) do
    room
    |> Map.has_key?(game_name)
  end

  def remove(room, game_name) do
    room
    |> Map.pop(game_name)
    |> case do
      {nil, room}         -> {:error, "Game does not exist", room}
      {player, new_room}  -> {:ok, player, new_room}
    end
  end
end
