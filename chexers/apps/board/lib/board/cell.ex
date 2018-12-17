defmodule Game.Board.Cell do
  use TypedStruct

  # utilizing typedstuct system in order to prevent
  # invalid information being inserted into cell
  typedstruct enforce: true do
    field :row, 0..8
    field :col, 0..8
    field :movable?, boolean, default: false
    field :occupier, :black | :white | nil, enforce: false, default: nil
  end
end
