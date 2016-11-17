defmodule Pwc.FetchPeerInfo do
  alias Pwc.Firewall
  alias Pwc.Interface
  alias Pwc.IpNeighbor
  import Phoenix.Controller
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    {peer_addr, _peer_port} = conn.peer

    conn
    |> assign(:remote_ip4, conn.remote_ip)
    |> assign(:remote_ip6, conn.remote_ip |> IpNeighbor.mac_of_ip4 |> IpNeighbor.ip6_of_mac)
    |> assign(:remote_mac, conn.remote_ip |> IpNeighbor.mac_of_ip4)
    |> assign(:remote_allowed, conn.remote_ip |> IpNeighbor.mac_of_ip4 |> Firewall.is_mac_allowed)
    |> assign(:is_admin, is_ip4_in_network?(peer_addr, Interface.eth_ip4))
  end

  @doc """
  VERY DIRTY
  """
  defp is_ip4_in_network?({a1, a2, _, _} = ip4_address, {b1, b2, _, _} = ip4_network) do
    a1 === b1 and a2 === b2
  end

end
