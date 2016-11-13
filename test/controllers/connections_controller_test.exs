defmodule Pwc.ConnectionsControllerTest do
  use Pwc.ConnCase

  alias Pwc.Connections
  @valid_attrs %{ipv4_addr: "some content", ipv6_addr: "some content", mac_addr: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, connections_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing connections"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, connections_path(conn, :new)
    assert html_response(conn, 200) =~ "New connections"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, connections_path(conn, :create), connections: @valid_attrs
    assert redirected_to(conn) == connections_path(conn, :index)
    assert Repo.get_by(Connections, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, connections_path(conn, :create), connections: @invalid_attrs
    assert html_response(conn, 200) =~ "New connections"
  end

  test "shows chosen resource", %{conn: conn} do
    connections = Repo.insert! %Connections{}
    conn = get conn, connections_path(conn, :show, connections)
    assert html_response(conn, 200) =~ "Show connections"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, connections_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    connections = Repo.insert! %Connections{}
    conn = get conn, connections_path(conn, :edit, connections)
    assert html_response(conn, 200) =~ "Edit connections"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    connections = Repo.insert! %Connections{}
    conn = put conn, connections_path(conn, :update, connections), connections: @valid_attrs
    assert redirected_to(conn) == connections_path(conn, :show, connections)
    assert Repo.get_by(Connections, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    connections = Repo.insert! %Connections{}
    conn = put conn, connections_path(conn, :update, connections), connections: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit connections"
  end

  test "deletes chosen resource", %{conn: conn} do
    connections = Repo.insert! %Connections{}
    conn = delete conn, connections_path(conn, :delete, connections)
    assert redirected_to(conn) == connections_path(conn, :index)
    refute Repo.get(Connections, connections.id)
  end
end
