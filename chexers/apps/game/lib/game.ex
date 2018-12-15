defmodule Game do
  alias Game.Board.Cell
  use TypedStruct

  typedstruct do
    field :board, list(Cell)
    field :game_pieces, %{white: integer, blacK: integer},  default: %{white: 12, black: 12}
    field :winner, :white | :black | nil, default: nil
    field :game_status, atom(), default: :initializing
    field :current_turn, :white | :black | nil, default: nil
  end

  defdelegate new_game(),                   to: Game.Create
  defdelegate move(game, player, from, to), to: Game.Move
end
