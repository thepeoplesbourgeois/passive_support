defmodule PassiveSupport.List do
  @doc """
  Not to be confused with `Enum.map/2`, returns a `Map` out of the given list
  with the index of each item being the item's key

  ## Examples

      iex> Ps.List.to_map(["hello", "world", "how", "are", "you"])
      %{0 => "hello", 1 => "world", 2 => "how", 3 => "are", 4 => "you"}

      iex> Ps.List.to_map(["Elixir", "is",  "cool"])
      %{0 => "Elixir", 1 => "is", 2 => "cool"}
  """
  def to_map(list) do
    list
    |> to_map(fn (_item, item_index) -> item_index end)
  end

  @doc ~S"""
  Not to be confused with Enum.map/2, returns a `Map` with the key for each
  item derived by the return of `key_function(item [, item_index])`

  ## Examples

      iex> Ps.List.to_map(["Elixir", "is",  "cool"], &(String.reverse(&1)))
      %{"si" => "is", "looc" => "cool", "rixilE" => "Elixir"}

      iex> Ps.List.to_map(["hello", "world", "how", "are", "you"], fn (_, index) -> index end)
      %{0 => "hello", 1 => "world", 2 => "how", 3 => "are", 4 => "you"}
  """
  def to_map(list, key_function) when is_function(key_function, 1) do
    list
    |> Enum.reduce(%{}, fn (item, map) -> put_in(map[key_function.(item)], item) end)
  end
  def to_map(list, key_function) when is_function(key_function, 2) do
    list
    |> Stream.with_index
    |> Enum.reduce(%{}, fn ({item, item_index}, map) -> put_in(map[key_function.(item, item_index)], item) end)
  end

  #  TODO permutations/1 should return the possible shuffles of the list
  #  def permutations([head|tail]), do: permutations([head|tail], length([head|tail]))

  @doc ~S"""
  Returns all the potential permutations of `sublist_length` for the given list

  ## Examples

      iex> Ps.List.permutations(["love", "money", "health"], 2)
      [["love", "money"], ["love", "health"], ["money", "health"]]
  """
#  def permutations(list, sublist_length)
#  def permutations([], _), do: []
#  def permutations(_, 0), do: [[]]
#  def permutations([element|rest], sublist_length), do: ((for subset <- permutations(rest, sublist_length - 1), do: [element|subset]) ++ permutations(rest, sublist_length))
end