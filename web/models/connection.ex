defmodule Pwc.Connection do
  use Pwc.Web, :model

  schema "connections" do
    field :mac_addr, :string
    field :ipv4_addr, :string
    field :ipv6_addr, :string

    belongs_to :user, Pwc.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:mac_addr, :ipv4_addr, :ipv6_addr])
    |> validate_required([:mac_addr, :ipv4_addr, :ipv6_addr])
  end
end
