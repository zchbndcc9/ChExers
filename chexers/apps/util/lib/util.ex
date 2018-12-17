defmodule Util do
  @type coords :: %{row: integer, col: integer}

  @spec get_middle_coords(coords, coords) :: coords
  def get_middle_coords(%{row: r1, col: c1}, %{row: r2, col: c2}) do
    case {r1 - r2, c1 - c2} do
      {-2, 2} -> %{row: r1+1, col: c1-1}
      {2, -2} -> %{row: r1-1, col: c1+1}
      {-2, -2} -> %{row: r1+1, col: c1+1}
      {2, 2} -> %{row: r1-1, col: c1-1}
    end
  end
end
