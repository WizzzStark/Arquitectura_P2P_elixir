defmodule MsgSuperPeer do
  use DynamicSupervisor
  require Logger

  @doc """
  Inicia el DynamicSupervisor para los procesos Peer.

  ## Parámetros

    - _arg: Argumentos de inicialización (no utilizados).

  ## Retorna

    - {:ok, pid} si el supervisor se inicia correctamente.
  """
  @spec start_link(any()) :: GenServer.on_start()
  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Inicia un nuevo proceso Peer como hijo del supervisor.

  ## Parámetros

    - peer_name: el nombre único del peer a iniciar.

  ## Retorna

    - {:ok, child_pid} | {:error, reason} dependiendo del resultado.
  """
  @spec start_child(String.t()) :: DynamicSupervisor.on_start_child()
  def start_child(peer_name) do
    child_specification = {Peer, peer_name}
    DynamicSupervisor.start_child(__MODULE__, child_specification)
  end

  @impl true
  def init(_arg) do
    Logger.info("MsgSuperPeer initialized...")
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
