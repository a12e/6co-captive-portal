defmodule Pwc.AdminFirewall do
  alias Pwc.Interface
  import Phoenix.Controller
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    {peer_addr, _peer_port} = conn.peer
    
    case is_ip4_in_network?(peer_addr, Interface.eth_ip4) do
      true -> 
        Logger.info "Authorized peer #{peer_addr |> :inet.ntoa |> to_string} in the admin panel"
        conn
      false ->
        Logger.info "Access denied for peer #{peer_addr |> :inet.ntoa |> to_string} to the admin panel"
        conn
        |> send_resp(:forbidden, "Non autorisé")
        |> halt()
    end
  end
  
  @doc """
  VERY DIRTY
  """
  defp is_ip4_in_network?({a1, a2, _, _} = ip4_address, {b1, b2, _, _} = ip4_network) do
    a1 === b1 and a2 === b2
  end
  
end
 
