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
    |> create_cells(8, 8)
    |> (&(%Board{ cells: &1 })).()
  end

  defp create_cols(cells, _row, -1) do
    cells
  end

  defp create_cols(cells, row, col) do
    create_cols([cells | [%Cell{row: row, col: col}]], row, col-1)
  end

  defp create_cells(cells, row, col) do
    0..row
    |> Enum.map(fn row -> create_cols(cells, row, col) end)
    |> List.flatten
  end
end
