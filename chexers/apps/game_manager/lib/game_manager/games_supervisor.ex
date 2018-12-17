defmodule GameManager.GamesSupervisor do
  use DynamicSupervisor
  alias GameManager.Games

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_game() do
    name = AnonymousNameGenerator.generate_random()
    child_spec = {Games, name}
    {status, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)

    {status, name}
  end

  def delete_game(name) do
    case Registry.lookup(:game_registry, name) do
      [] -> {:error, "Game does not exist"}
      [{pid, _name}] ->
        DynamicSupervisor.terminate_child(__MODULE__, pid)
        {:ok, "Game deleted"}
    end
  end
end
