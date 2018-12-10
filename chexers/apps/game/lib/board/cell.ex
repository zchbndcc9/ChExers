defmodule Game.Board.Cell do
  use TypedStruct

  # defstruct utilizing typedstuct system ni order to prevent
  # invalid information being inserted into cell
  typedstruct enforce: true do
    field: :row, non_neg_integer()
    field: :column, non_neg_integer()
    field: :occupier, :black | :white | nil, default: nil
  end
end
