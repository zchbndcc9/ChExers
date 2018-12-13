defmodule Game.Board.CellTest do
  use ExUnit.Case
  alias Game.Board.Cell

  describe "cell creation when" do
    test "row and col provided" do
      cell = %Cell{ row: 0, col: 1 }
      assert cell.row === 0
      assert cell.col === 1
      assert cell.occupier === nil
    end

    test "all fields populated" do
      cell = %Cell{ row: 1, col: 8, occupier: :red }
      assert cell.row === 1
      assert cell.col === 8
      assert cell.occupier === :red
    end
  end
end
