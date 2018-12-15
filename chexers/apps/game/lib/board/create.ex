defmodule Game.Board.Create do
  alias Game.Board.Cell
  # Macro used in order to secure board creation function while keeping the
  # guard nice and concise.
  defmacro is_valid_size(size) do
    quote do
      is_integer(unquote(size)) and unquote(size) > 0
    end
  end

  @spec create(integer()) :: {:ok, list(Cell)} | {:error, String}
  def create(size) when is_valid_size(size) do
    board =
      0..size-1
      |> Enum.map(fn row -> Task.async(fn -> create_row([], row, size-1) end) end)
      |> Enum.map(fn task -> Task.await(task) end)
      |> List.flatten
    {:ok, board}
  end

  def create(_) do
    {:error, "Must supply a positive integer for size"}
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
