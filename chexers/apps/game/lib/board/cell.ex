defmodule Game.Board.Cell do
  use TypedStruct

  # defstruct utilizing typedstuct system ni order to prevent
  # invalid information being inserted into cell
  typedstruct enforce: true do
    field :row, 0..8
    field :column, 0..8
    field :occupier, :black | :white | nil, enforce: false, default: nil
  end
end
