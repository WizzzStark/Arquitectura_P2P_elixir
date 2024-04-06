defmodule MsgP2p.Application do
  use Application

  @registry :peer_registry

  def start(_type, _args) do
    children = [
      {MsgSuperPeer, []},
      {Registry, keys: :unique, name: @registry}
    ]

    opts = [strategy: :one_for_one, name: MsgP2p.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
