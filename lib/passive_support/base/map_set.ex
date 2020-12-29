defmodule PassiveSupport.MapSet do
  @dialyzer {:nowarn_function, toggle: 2}

  @doc ~S"""
  Adds `element` to `set` if it isn't already a member, and deletes it if it is.

  ## Examples

      iex> MapSet.new(["ketchup", "pickles"])
      ...>   |> Ps.MapSet.toggle("mustard")
      ...>   |> Ps.MapSet.toggle("pickles")
      ...>   |> Ps.MapSet.toggle("barbecue sauce")
      #MapSet<["barbecue sauce", "ketchup", "mustard"]>

  """
  @spec toggle(MapSet.t, any) :: MapSet.t
  def toggle(%MapSet{} = set, element), do:
    if MapSet.member?(set, element),
      do: MapSet.delete(set, element),
      else: MapSet.put(set, element)
end
