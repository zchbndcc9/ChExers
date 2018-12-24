defmodule GameMatcher.WaitingRoom.Impl do
  alias GameMatcher.WaitingRoom.Impl
  defstruct room: %{}

  def put_in(%Impl{room: room}, player, game_name) do
    new_room =
      room
      |> Map.put_new(game_name, player)

    {:ok, %Impl{room: new_room}}
  end

  def exists?(%Impl{room: room}, game_name) do
    room
    |> Map.has_key?(game_name)
  end

  def remove(%Impl{room: room}, game_name) do
    room
    |> Map.pop(game_name)
    |> case do
      {nil, room}         -> {:error, "Game does not exist", %Impl{room: room}}
      {player, new_room}  -> {:ok, player, %Impl{room: new_room}}
    end
  end
end
