defmodule Game.Board do
  alias Game.Board.Cell

  @spec create(integer()) :: list(Cell)
  def create(size \\ 8) do
    0..size-1
    |> Enum.map(fn row -> Task.async(fn -> create_row([], row, size-1) end) end)
    |> Enum.map(fn task -> Task.await(task) end)
    |> List.flatten
  end

  defp create_row(cells, _row, -1) do
    cells
  end

  defp create_row(cells, row, col) do
    [%Cell{row: row, col: col, movable?: movable?(row, col)} | cells]
    |> create_row(row, col-1)
  end

  defp movable?(row, col) do
    case {rem(row, 2), rem(col, 2)} do
      {same, same} -> true
      {_, _} -> false
    end
  end
end
