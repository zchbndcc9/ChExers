defmodule Game.Board do
  use TypedStruct
  alias Game.Board.Cell
  alias Game.Board

  typedstruct do
    field :cells, list(Cell), default: []
    field :white_pieces, non_neg_integer, default: 12
    field :black_pieces, non_neg_integer, default: 12
  end

  @spec create() :: Game.Board.t()
  def create() do
    []
    |> create_cells(11, 11)
    |> (&(%Board{ cells: &1 })).()
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
