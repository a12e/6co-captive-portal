defmodule Pwc.RedirectToAuth do
  import Phoenix.Controller
  import Plug.Conn
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    host = conn
    |> get_req_header("host")
    |> Enum.at(0)
    
    if String.contains?(host, "172.16.0.254") do
      # Requests to us continue to normal flow
      conn
    else
      # Requests to outside world are catched here
      Logger.info "Redirected from #{requested_url(conn)}"
      encoded_url = conn |> requested_url |> URI.encode
      conn
      |> redirect(external: "http://172.16.0.254/login?url=#{encoded_url}")
      |> halt
    end
  end
  
  defp requested_url(conn) do
    case conn.query_string === "" do
      true -> "http://#{conn.host}#{conn.request_path}"
      false -> "http://#{conn.host}#{conn.request_path}?#{conn.query_string}"
    end
  end
end
