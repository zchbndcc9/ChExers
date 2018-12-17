defmodule Game.Move do
  alias Board.Cell
  alias Game.Util
  alias Game.Move.Validate

  @type player    :: :white | :black
  @type coords    ::  %{row: integer, col: integer}
  @type move_flag ::  :ok | :invalid_move | :wrong_piece |
                      :invalid_coord | :no_piece |
                      :possible_hop | :invalid_hop | :hop |
                      :blocked | :same_location

  # Guard to ensure that game is not altered once it has already been won
  @spec move(%Game{}, player, coords, coords) :: {move_flag, %Game{}}
  def move(game = %Game{game_status: :won}, _player, _from, _to) do
    {:ok, game}
  end

  def move(game = %Game{}, player, from, to) do
    {status, game} =
      game
      |> Validate.validate(player, from, to)
      |> move_piece(player, from, to)
      |> update_game()
      |> determine_game_status()
      |> change_player_turn()

    {status, game}
  end

  defp move_piece({:ok, game}, player, from, to) do
    new_board =
      game.board
      |> Board.move(player, from, to)

    {:ok, %Game{game | board: new_board}}
  end

  defp move_piece({:hop, game}, player, from, to) do
   piece_to_remove = %Cell{occupier: opponent} = Board.get_hopped_cell(game.board, from, to)

    new_board =
      game.board
      |> Board.move(player, from, to)
      |> Board.remove(piece_to_remove)

    %{white: w, black: b} = game.game_pieces
    updated_pieces =
      #TO DO extract to own function
      case opponent do
        :white -> %{white: w-1, black: b}
        :black -> %{white: w, black: b-1}
      end
    {:ok, %Game{ game | game_pieces: updated_pieces, board: new_board }}
  end

  defp move_piece({status, game}, _player, _from, _to), do: {status, game}

  defp update_game({:ok, game}) do
    {:ok, game}
  end

  defp update_game({status, game}), do: {status, game}

  # I was torn on whether to pattern match or use cases, but I went with the
  # latter since I think it leads to clean, more concise code
  defp determine_game_status({status, game}) do
    game = case game do
      %Game{ game_pieces: %{white: 0} } -> %Game{ game | winner: :black, game_status: :won }
      %Game{ game_pieces: %{black: 0} } -> %Game{ game | winner: :white, game_status: :won }
      _ -> %Game{ game | game_status: :in_progress}
    end

    {status, game}
  end

  defp change_player_turn({:ok, game = %Game{ current_turn: player }}) do
    next_player = Util.get_opponent(player)

    {:ok, %Game{ game | current_turn: next_player}}
    end
  end

  defp change_player_turn({status, game}) do
    {status, game}
  end
end
