defmodule ServerWeb.CellView do
  use ServerWeb, :view

  def render("show.json", %{"cell" => cell}) do
    %{
      row: cell.row,
      col: cell.col,
      movable?: cell.movable?,
      occupier: cell.occupier
    }
  end
end
