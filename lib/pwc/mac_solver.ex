defmodule Pwc.MacSolver do

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

end
