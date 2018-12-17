defmodule Game.Play do
  def play(%Game{board: board, game_status: :won, winner: player}) do
    Game.Board.draw(board)
    IO.puts "Congrats to #{player} for winning!"
  end

  def play(game = %Game{current_turn: player, board: board}) do
    Game.Board.draw(board)

    print_stats(game)

    {from, to} =
      Player.determine_move()
      |> format_coords()
      |> List.to_tuple()

    case Game.Move.move(game, player, from, to) do
      {:ok, game} ->
        next_player = get_opponent(player)
        play(%Game{ game | current_turn: next_player })
      {status, game} ->
        # Print out reason
        IO.inspect status
        play(game)
    end
  end

  def play(_), do: nil

  defp format_coords(move) do
    move
    |> Enum.map(fn {row, col} -> %{row: row, col: col} end)
  end

  defp print_stats(%Game{ current_turn: player, game_pieces: %{black: black, white: white}}) do
    IO.puts "Current turn: #{player}"
    IO.puts "Black: #{black} | White: #{white}"
  end

  @spec get_opponent(:black | :white) :: :black | :white
  def get_opponent(:white), do: :black
  def get_opponent(:black), do: :white
end
