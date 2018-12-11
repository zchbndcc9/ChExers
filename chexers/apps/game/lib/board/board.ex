defmodule Game.Board do
  alias Game.Board.Cell

  @spec create() :: list(Cell)
  def create() do
    []
    |> create_cells(11, 11)
  end

  defp create_row(cells, _row, -1) do
    cells
  end

  defp create_row(cells, row, col) do
    [cells | [%Cell{row: row, col: col, movable?: movable?(row, col)}]]
    |> create_row(row, col-1)
  end

  def movable?(row, col) do
    case {rem(row, 2), rem(col, 2)} do
      {0, 0} -> true
      {1, 1} -> true
      {_, _} -> false
    end
  end

  # Creates cells asyncronously
  defp create_cells(cells, row, col) do
    0..row
    |> Enum.map(fn row -> Task.async(fn -> create_row(cells, row, col) end) end)
    |> Enum.map(fn task -> Task.await(task) end)
    |> List.flatten
  end
end
