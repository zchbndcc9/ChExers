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
end
