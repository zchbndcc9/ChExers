defmodule Player do
  def determine_move() do
    get_move()
    # |> check_valid_format()
    |> parse_move()
  end

  def get_move() do
    IO.gets "Enter coordinates for where you would like to move\nFormat: {row, col} -> {row, col}\n"
  end

  def parse_move(move) do
    move
    |> String.trim
    |> String.split("->")
    |> Enum.map(fn str -> String.trim(str) end)
    |> Enum.map(fn str -> extract_tuples(str) end)
  end

  defp extract_tuples(string) do
    ~r/\d+/
    |> Regex.scan(string)
    |> List.flatten
    |> Enum.map(fn num -> String.to_integer(num) end)
    |> List.to_tuple
  end

end
