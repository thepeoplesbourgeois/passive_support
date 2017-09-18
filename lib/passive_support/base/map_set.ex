defmodule PassiveSupport.MapSet do

  @doc ~S"""
  Adds `element` to `set` if it isn't already a member, and deletes it if it is.

  ## Examples

      iex> MapSet.new(["ketchup", "pickles"])
      ...>   |> Ps.MapSet.toggle("mustard")
      ...>   |> Ps.MapSet.toggle("pickles")
      #MapSet<["ketchup", "mustard"]>

  """
  @spec toggle(MapSet.t, any) :: MapSet.t
  def toggle(set = %MapSet{}, element) do
    case MapSet.member?(set, element) do
    true ->
      MapSet.delete(set, element)
    false ->
      MapSet.put(set, element)
    end
  end

end