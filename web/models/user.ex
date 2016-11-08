defmodule Pwc.User do
  use Pwc.Web, :model

  schema "users" do
    field :username, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> put_encrypted_password(params)
    |> validate_required([:username, :encrypted_password])
  end

  defp put_encrypted_password(changeset, params) do
    case Map.fetch(params, "password") do
      {:ok, password} ->
        changeset
        |> put_change(:encrypted_password, password |> Comeonin.Bcrypt.hashpwsalt)
      :error ->
        changeset
    end
  end
end
