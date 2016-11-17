defmodule Pwc.IpNeighbor do
  alias Pwc.Interface

  @spec mac_of_ip4(ip :: :inet.ip4_address) :: String.t
  def mac_of_ip4(ip) do
    {result, _exit_code} = System.cmd "ip", ["neighbor"]

    result
    |> String.split("\n")
    |> Enum.find(nil, fn(line) -> String.contains?(line, to_string(:inet.ntoa ip)) end)
    |> String.split(" ")
    |> Enum.at(4) # example: 192.168.1.251 dev eth0 lladdr 8c:a9:82:86:47:62 REACHABLE
  end

  @spec ip6_of_mac(mac_addr :: String.t) :: :inet.ip6_address
  def ip6_of_mac(mac_addr) do
    {result, _exit_code} = System.cmd "ip", ["-6", "neighbor"]

    line = result
    |> String.split("\n")
    |> Enum.find(nil, fn(line) ->
        String.contains?(line, mac_addr)
        and not String.contains?(line, "fe80::") # we don't want link-local addresses
    end)

    case line do
      nil -> {:error, :einval}
      line -> parse_result = line
              |> String.split(" ")
              |> Enum.at(0) # example: 2001:470:1f13:784:144d:b972:c5c5:a4cd dev wlan0 lladdr c0:ee:fb:26:d0:04 REACHABLE
              |> to_charlist # Erlang wants char list and not string
              |> :inet.parse_ipv6_address # string to ip6_address

              case parse_result do
                {:ok, ipv6} -> ipv6
                error -> error
              end
    end
  end
  
  @spec wlan_neighbors() :: [{mac :: String.t, ipv4 :: String.t, ipv6 :: String.t}]
  def wlan_neighbors() do
    wlan_mac_str = Interface.wlan_mac |> Interface.mac_to_string
    
    {result, _exit_code} = System.cmd "ip", ["-4", "neighbor"]
    ipv4_stations = result
    |> String.split("\n")
    |> Enum.filter(fn(line) -> String.contains?(line, "wlan0") end)
    |> Enum.filter(fn(line) -> !String.contains?(line, wlan_mac_str) end)
    |> Enum.map(fn(line) ->       # "172.16.0.19 dev wlan0 lladdr c0:ee:fb:26:d0:04 REACHABLE"
        cols = line |> String.split
        {Enum.at(cols, 4), Enum.at(cols, 0)}
       end)
    |> Enum.filter(fn({mac, _ipv4}) -> !is_nil(mac) end) # don't include disconnected stations
    
    {result, _exit_code} = System.cmd "ip", ["-6", "neighbor"]
    ipv6_stations = result
    |> String.split("\n")
    |> Enum.filter(fn(line) -> String.contains?(line, "wlan0") end)
    |> Enum.filter(fn(line) -> !String.contains?(line, wlan_mac_str) end)
    |> Enum.filter(fn(line) -> !String.contains?(line, "fe80::") end) # don't include link-local addresses
    |> Enum.map(fn(line) ->       # "fe80::c2ee:fbff:fe26:d004", "dev", "wlan0", "lladdr", "c0:ee:fb:26:d0:04", "REACHABLE"
        cols = line |> String.split
        {Enum.at(cols, 4), Enum.at(cols, 0)}
       end)
    |> Enum.filter(fn({mac, _ipv6}) -> !is_nil(mac) end) # don't include disconnected stations
    
    # merge the ipv4 and ipv6 tuples
    ipv4_stations
    |> Enum.map(fn({mac, ipv4}) -> 
        {_, ipv6} = Enum.find(ipv6_stations, {mac, nil}, fn({other_mac, _ipv6}) -> other_mac === mac end)
        {mac, ipv4, ipv6}
      end)
  end

end
