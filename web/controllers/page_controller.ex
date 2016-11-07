defmodule Pwc.PageController do
  use Pwc.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", conn: conn
  end
end
