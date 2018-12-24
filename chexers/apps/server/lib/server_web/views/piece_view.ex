defmodule ServerWeb.PieceView do
  use ServerWeb, :view

  def render("show.json", %{"piece" => cell}) do
    %{
      row: cell.row,
      col: cell.col,
      occupier: cell.occupier
    }
  end
end
