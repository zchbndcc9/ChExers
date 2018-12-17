defmodule Game.Create do
  def new_game() do
    board = Board.create()

    {:ok, %Game{ board: board }}
  end
end
