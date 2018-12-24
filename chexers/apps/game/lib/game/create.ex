defmodule Game.Create do
  alias Game.Board
  
  def new_game() do
    {_status, board} = Board.create()

    {:ok, %Game{ board: board }}
  end
end
