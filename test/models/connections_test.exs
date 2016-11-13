defmodule Pwc.ConnectionsTest do
  use Pwc.ModelCase

  alias Pwc.Connections

  @valid_attrs %{ipv4_addr: "some content", ipv6_addr: "some content", mac_addr: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Connections.changeset(%Connections{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Connections.changeset(%Connections{}, @invalid_attrs)
    refute changeset.valid?
  end
end
