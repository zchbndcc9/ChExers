defmodule GamesManager.Supervisor do
  use DynamicSupervisor

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_game() do
    child_spec = {Games}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
