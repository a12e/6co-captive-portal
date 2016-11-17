defmodule Pwc.AdminFirewall do
  alias Pwc.Interface
  import Phoenix.Controller
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    {peer_addr, _peer_port} = conn.peer

    case conn.assigns[:is_admin] do
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

end
