defmodule Pwc.Interface do
 
  @doc """
  Returns the IPv4 address of the eth0 interface of the Pi
  """
  @spec eth_ip4() :: [byte()]
  def eth_ip4() do
    with {:ok, iface_list} <- :inet.getifaddrs,
    do: iface_list |> find_interface_detail('eth0', :addr)
  end 
 
  @doc """
  Returns the MAC address of the wlan0 interface of the Pi
  """
  @spec wlan_mac() :: [byte()]
  def wlan_mac() do
    with {:ok, iface_list} <- :inet.getifaddrs,
    do: iface_list |> find_interface_detail('wlan0', :hwaddr)
  end
  
  defp find_interface_detail(iface_list, iface_name, field) do
    case iface_list do
      [] -> {:error, "No MAC address found"}
      [interface | tail] ->
        case interface do
          {^iface_name, iface_details} -> iface_details[field]
          _ -> find_interface_detail(tail, iface_name, field)
        end
    end
  end
  
  @doc """
  Converts a 6-byte MAC address into its downcase string representation
  """
  @spec mac_to_string(mac_addr :: [byte()]) :: String.t
  def mac_to_string(mac_addr) do
    mac_addr
    |> Enum.map(fn(byte) -> byte |> Integer.to_string(16) |> String.downcase end)
    |> Enum.join(":")
  end

end
 
