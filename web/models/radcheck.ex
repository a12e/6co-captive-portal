defmodule Pwc.Radcheck do
  use Pwc.Web, :model
  
  schema "radcheck" do
    field :username, :string
    field :attribute, :string
    field :op, :string
    field :value, :string
  end
  
end
