defmodule Pwc.MacSolver do

  @spec mac_of_ip(ip :: :inet.ip_address) :: String.t
  def mac_of_ip(ip) do
    {result, _exit_code} = System.cmd "ip", ["neigh"]
        
    result
    |> String.split("\n")
    |> Enum.find(nil, fn(line) -> String.contains?(line, to_string(:inet_parse.ntoa ip)) end)
    |> String.split(" ")
    |> Enum.at(4) # example: 192.168.1.251 dev eth0 lladdr 8c:a9:82:86:47:62 REACHABLE
  end

end
