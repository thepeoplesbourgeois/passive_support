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
  @spec to_map(list) :: Map.t
  def to_map(list), do:
    list
      |> to_map(fn (_item, item_index) -> item_index end)

  @doc ~S"""
  Not to be confused with Enum.map/2, returns a `Map` with the key for each
  item derived by the return of `key_function(item [, item_index])`

  ## Examples

      iex> Ps.List.to_map(["Elixir", "is",  "cool"], &(String.reverse(&1)))
      %{"si" => "is", "looc" => "cool", "rixilE" => "Elixir"}

      iex> Ps.List.to_map(["hello", "world", "how", "are", "you"], fn (_, index) -> index end)
      %{0 => "hello", 1 => "world", 2 => "how", 3 => "are", 4 => "you"}
  """
  @spec to_map(list, function) :: Map.t
  def to_map(list, key_function) when is_function(key_function, 1), do:
    list
      |> Enum.reduce(%{}, fn (item, map) -> put_in(map[key_function.(item)], item) end)

  def to_map(list, key_function) when is_function(key_function, 2), do:
    list
      |> Stream.with_index
      |> Enum.reduce(%{}, fn ({item, item_index}, map) -> put_in(map[key_function.(item, item_index)], item) end)

  @doc ~S"""
  Returns a copy of `list` with any `nil` values removed

  ## Examples

      iex> Ps.List.compact([1,nil,3])
      [1, 3]

      iex> Ps.List.compact([false, nil, nil, "hi"])
      [false, "hi"]
  """
  @spec compact(list) :: list
  def compact(list), do:
    compact(list, [])
  def compact([], acc), do:
    Enum.reverse(acc)
  def compact([nil | tail], acc), do:
    compact(tail, acc)
  def compact([head | tail], acc), do:
    compact(tail, [head | acc])


  @doc ~S"""
  Performs the provided function on every non-nil value while removing nil values.
  If `also_filter_result` is passed, then any nil values that would be returned
  from the function are not injected into the list.

  ## Examples

      iex> Ps.List.compact_map([1,2,nil,4], &(&1 * 2))
      [2,4,8]

      iex> Ps.List.compact_map([nil, "   ", {}, 0], &Ps.Item.presence/1, also_filter_result: true)
      [0]
  """
  def compact_map(list, fun), do:
    compact_map(list, fun, [], also_filter_result: false)
  def compact_map(list, fun, options \\ [also_filter_result: false]), do:
    compact_map(list, fun, [], options)

  defp compact_map([], _fun, acc, _options), do:
    Enum.reverse(acc)
  defp compact_map(list, fun, acc, []), do:
    compact_map(list, fun, acc, also_filter_result: false)
  defp compact_map([nil|tail], fun, acc, options), do:
    compact_map(tail, fun, acc, options)
  defp compact_map([head|tail], fun, acc, [also_filter_result: true] = options) do
    result = fun.(head)
    if result, do: compact_map(tail, fun, [result | acc], options), else: compact_map(tail, fun, acc, options)
  end
  defp compact_map([head|tail], fun, acc, [also_filter_result: false] = options), do:
    compact_map(tail, fun, [fun.(head) | acc], options)


  #  TODO permutations/1 should return the possible shuffles of the list
  #  def permutations([h|t]), do: permutations([h|t], length([h|t]))

  @doc ~S"""
  Returns all the potential permutations of `sublist_length` for the given list

  ## Examples

      iex> Ps.List.permutations(["love", "money", "health"], 2)
      [["love", "money"], ["love", "health"], ["money", "health"]]
  """
# BROKEN: Only returning `[ ["love", "money"] ]` in the current implementation
#  def permutations(list, sublist_length)
#  def permutations([], _), do: []
#  def permutations(_, 0), do: [[]]
#  def permutations([element|rest], sublist_length), do: ((for subset <- permutations(rest, sublist_length - 1), do: [element|subset]) ++ permutations(rest, sublist_length))
end
