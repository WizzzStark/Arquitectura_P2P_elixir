defmodule Peer do
  use GenServer
  require Logger

  # Identificador único para el Registry de peers.
  @registry :peer_registry

  @doc """
  Inicia un enlace a un nuevo proceso Peer, identificado por un nombre único.

  ## Parámetros

  - name: El nombre único del peer dentro de la red.

  ## Retorna

  {:ok, pid} si el proceso se inicia correctamente, o {:error, reason} si falla.
  """
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(name) do
    GenServer.start_link(__MODULE__, {name, []}, name: via_tuple(name))
  end

  @doc false
  defp via_tuple(name), do: {:via, Registry, {@registry, "#{name}"}}

  @doc """
  Envía un mensaje a otro peer identificado por `peer_name`.

  ## Parámetros

  - peer_name: El nombre del peer destinatario.
  - message: El mensaje a enviar.

  ## Retorna

  :ok si el mensaje se envió correctamente, o {:error, reason} si falla.
  """
  @spec send_message(String.t(), any()) :: :ok | {:error, any()}
  def send_message(peer_name, message) do
    peer_name |> via_tuple() |> GenServer.call({:send_message, message})
  end

  @doc """
  Obtiene los mensajes recibidos por el peer identificado por `peer_name`.

  ## Parámetros

  - peer_name: El nombre del peer.

  ## Retorna

  Una lista de mensajes recibidos.
  """
  @spec get_messages(String.t()) :: list()
  def get_messages(peer_name) do
    peer_name |> via_tuple() |> GenServer.call(:get_messages)
  end

  @doc """
  Detiene el proceso del peer identificado por `peer_name`.

  ## Parámetros

  - peer_name: El nombre del peer a detener.

  ## Retorna

  :ok si el proceso se detuvo correctamente, o {:error, reason} si falla.
  """
  @spec stop(String.t()) :: :ok | {:error, any()}
  def stop(peer_name) do
    GenServer.stop(via_tuple(peer_name), :normal, :infinity)
  end

  @doc """
  Actualiza el perfil de un peer identificado por `peer_name`.

  ## Parámetros

  - peer_name: El nombre del peer.
  - new_profile: El nuevo perfil del peer.

  ## Retorna

  :ok si el perfil se actualizó correctamente, o {:error, reason} si falla.
  """
  @spec update_profile(String.t(), any()) :: :ok | {:error, any()}
  def update_profile(peer_name, new_profile) do
    peer_name |> via_tuple() |> GenServer.call({:update_profile, new_profile})
  end

  @doc """
  Obtiene el perfil de un peer identificado por `peer_name`.

  ## Parámetros

  - peer_name: El nombre del peer.

  ## Retorna

  El perfil del peer si está presente, o "No profile set" si no se ha establecido.
  """
  @spec get_profile(String.t()) :: any()
  def get_profile(peer_name) do
    peer_name |> via_tuple() |> GenServer.call(:get_profile)
  end

  @doc """
  Lista todos los nombres de los peers actualmente registrados en el sistema.

  ## Ejemplo

      iex> Peer.list_peers()
      ["peer1", "peer2", "peer3"]

  ## Retorna

  Una lista de cadenas con los nombres de todos los peers registrados.
  """
  @spec list_peers() :: [String.t()]
  def list_peers do
    match_spec = [{{:"$1", :"$2", :_}, [], [:"$1"]}]
    Registry.select(@registry, match_spec)
  end

  @doc """
  Permite a un peer suscribirse a los mensajes de otro peer.

  ## Parámetros

    - subscriber_name: El nombre del peer que desea suscribirse.
    - publisher_name: El nombre del peer al que se suscribe.

  ## Retorna

    - :ok si la suscripción fue exitosa.
    - {:error, reason} si la suscripción falla.
  """
  @spec subscribe_to(String.t(), String.t()) :: :ok | {:error, any()}
  def subscribe_to(subscriber_name, publisher_name) do
    GenServer.cast(via_tuple(publisher_name), {:subscribe, subscriber_name})
  end

  @impl true
  def init({peer_name, _messages}) do
    Logger.info("Peer \"#{peer_name}\" joined the network...")
    {:ok, %{messages: [], subscribers: []}}
  end

  @impl true
  def handle_call({:send_message, message}, _from, state) do
    Logger.info("Message received")

    Enum.each(state.subscribers, fn subscriber_name ->
      send_message(subscriber_name, message)
    end)

    {:reply, :ok, %{state | messages: [message | state.messages]}}
  end

  @impl true
  def handle_call(:get_messages, _from, state) do
    {:reply, state.messages, state}
  end

  @impl true
  def handle_call({:update_profile, new_profile}, _from, state) do
    {:reply, :ok, Map.put(state, :profile, new_profile)}
  end

  @impl true
  def handle_call(:get_profile, _from, state) do
    {:reply, Map.get(state, :profile, "No profile set"), state}
  end

  @impl true
  def handle_cast({:subscribe, subscriber_name}, state) do
    new_subscribers = [subscriber_name | state.subscribers]
    {:noreply, %{state | subscribers: new_subscribers}}
  end
end
