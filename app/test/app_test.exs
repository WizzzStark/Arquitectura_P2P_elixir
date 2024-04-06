defmodule PeerTest do
  use ExUnit.Case

  test "peer can be started and stopped" do
    assert {:ok, _pid} = Peer.start_link("peer1")
    assert :ok = Peer.stop("peer1")
  end

  test "peer can send and receive messages" do
    {:ok, _pid1} = Peer.start_link("peer1")
    {:ok, _pid2} = Peer.start_link("peer2")

    assert :ok = Peer.send_message("peer2", "Hello, peer2!")
    assert ["Hello, peer2!"] = Peer.get_messages("peer2")

    Peer.stop("peer1")
    Peer.stop("peer2")
  end

  test "peer can update and get profile" do
    {:ok, _pid} = Peer.start_link("peer1")
    assert :ok = Peer.update_profile("peer1", %{age: 25})
    assert %{age: 25} = Peer.get_profile("peer1")

    Peer.stop("peer1")
  end

  test "peer subscription works correctly" do
    {:ok, _pid1} = Peer.start_link("peer1")
    {:ok, _pid2} = Peer.start_link("peer2")

    assert :ok = Peer.subscribe_to("peer2", "peer1")
    Peer.send_message("peer1", "Hello, peer2 through peer1!")

    assert ["Hello, peer2 through peer1!"] = Peer.get_messages("peer2")

    Peer.stop("peer1")
    Peer.stop("peer2")
  end
end
