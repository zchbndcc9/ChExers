defmodule Player do
  def determine_move() do
    get_move()
    |> ensure_valid_format()
    |> parse_move()
  end

  def get_move() do
    IO.gets "Enter coordinates for where you would like to move\nFormat: {row, col} -> {row, col}\n"
  end

  defp ensure_valid_format(move) do
    ~r/{\s*\d+\s*,\s*\d+\s*}\s*->\s*{\s*\d+\s*,\s*\d+\s*}/
    |> Regex.run(move)
    |> case do
      nil ->
        IO.puts "Whoops you entered an invalid formatted move. Try again:"
        determine_move()
      move -> List.to_string(move)
    end
  end

  defp parse_move(move) do
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
