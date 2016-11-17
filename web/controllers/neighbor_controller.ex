defmodule Pwc.NeighborController do
  alias Pwc.Firewall
  alias Pwc.Interface
  alias Pwc.IpNeighbor
  use Pwc.Web, :controller

  def index(conn, _params) do
    # add other information the connected stations (hostname and allowded through firewall)
    
    rich_wlan_neighbors = IpNeighbor.wlan_neighbors
    |> Enum.map(fn({mac, ipv4, ipv6}) ->
        hostname = case :inet.gethostbyaddr(to_charlist ipv4) do
          {:ok, {:hostent, hostname, _, _, _, _}} -> hostname
          {:error, _} -> ""
        end
        {mac, ipv4, ipv6, hostname, mac |> Firewall.is_mac_allowed}
      end) 
    
    conn
    |> assign(:eth_ip4, Interface.eth_ip4 |> :inet.ntoa |> to_string)
    |> render("index.html", wlan_neighbors: rich_wlan_neighbors)
  end
  
end
