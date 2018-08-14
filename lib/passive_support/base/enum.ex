defmodule PassiveSupport.Enum do
  require Logger
  @doc """
  Converts an enumerable to a `Map`, using the index of
  each item as the item's key.

  ## Examples

      iex> Ps.Enum.to_map(["hello", "world", "how", "are", "you"])
      %{0 => "hello", 1 => "world", 2 => "how", 3 => "are", 4 => "you"}

      iex> Ps.Enum.to_map(["Elixir", "is",  "cool"])
      %{0 => "Elixir", 1 => "is", 2 => "cool"}
  """
  @spec to_map(Enumerable.t) :: Map.t
  def to_map(enum), do:
    enum
      |> to_map(fn (_item, item_index) -> item_index end)

  @doc ~S"""
  Not to be confused with Enum.map/2, returns a `Map` with the key for each
  item derived by the return of `key_function(item [, item_index])`

  ## Examples

      iex> Ps.Enum.to_map(["Elixir", "is",  "cool"], &String.reverse/1)
      %{"si" => "is", "looc" => "cool", "rixilE" => "Elixir"}

      iex> Ps.Enum.to_map(["hello", "world", "how", "are", "you"], fn (_, index) -> index end)
      %{0 => "hello", 1 => "world", 2 => "how", 3 => "are", 4 => "you"}
  """
  @spec to_map(Enumerable.t, function) :: Map.t
  def to_map(enum, key_function) when is_function(key_function, 1), do:
    enum
      |> Stream.map(fn item -> {key_function.(item), item} end)
      |> Enum.into(%{})

  def to_map(enum, key_function) when is_function(key_function, 2), do:
    enum
      |> Stream.with_index
      |> Stream.map(fn {item, item_index} -> {key_function.(item, item_index), item} end)
      |> Enum.into(%{})


  @doc ~S"""
  Returns true if the given `fun` evaluates to false on all
  of the items in the enumberable.

  Iteration stops at the first invocation that returns a
  truthy value (not `false` or `nil`). Invokes an identity
  function if one is not provided.

  ## Examples

      iex> test_list = [1, 2, 3]
      ...> Ps.Enum.none?(test_list, &(&1 == 0))
      true
      ...> Ps.Enum.none?([0 | test_list], &(&1 == 0))
      false

      iex> Ps.Enum.none?([])
      true

      iex> Ps.Enum.none?([nil])
      true

      iex> Ps.Enum.none?([true])
      false
  """
  @spec none?(Enumerable.t, function) :: boolean
  def none?(enum, fun \\ &(&1))
  def none?(enum, fun), do: !Enum.any?(enum, fun)

    @doc ~S"""
  Generates a list of all possible permutations of the given list.
  If `stream: true` is passed,

  ## Examples

      iex> Ps.Enum.permutations(~W"hi ho hey!")
      [
        ["hi", "ho", "hey!"],
        ["hi", "hey!", "ho"],
        ["ho", "hi", "hey!"],
        ["ho", "hey!", "hi"],
        ["hey!", "hi", "ho"],
        ["hey!", "ho", "hi"]
      ]

      iex> alias PassiveSupport, as: Ps
      iex> 1..50 |> Ps.Enum.permutations(stream: true) |> Enum.take(2)
      [
        [1,2,3,4,5,6,7,8,9,10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         31,32,33,34,35,36,37,38,39,40,
         41,42,43,44,45,46,47,48,49,50],
         [1,2,3,4,5,6,7,8,9,10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         31,32,33,34,35,36,37,38,39,40,
         41,42,43,44,45,46,47,48,50,49]
      ]
  """
  @spec permutations([any], [stream: boolean()]) :: [[any]] | Stream.t
  def permutations(list, options \\ [])

  def permutations([], _), do: [[]]
  def permutations(enum, options) do
    lazy = enum
      |> to_map # necessary for fast access
      |> make_permutations
    if Keyword.get(options, :stream),
      do: lazy,
      else: Enum.to_list(lazy)
  end

  defp make_permutations(list) do
    list
      |> borken_permutations(0)
      # |> cursor_permutations(0, 0)
      # |> list_permutations
  end

  defp borken_permutations(map, _indent_level) when map_size(map) == 0 do
    [[]]
  end
  defp borken_permutations(map, indent_level) when is_map(map) do
    map
      |> Stream.flat_map(fn {index, next} ->
           submap = Map.delete(map, index)
           Logger.debug(debug_indent("inside flat_map", indent_level))
           Logger.debug(debug_indent("index: #{index}, next: #{next}", indent_level))
           Logger.debug(debug_indent("submap: #{inspect(submap)}", indent_level))
           Stream.map(borken_permutations(submap, indent_level+1), fn (submap) -> [next | submap] end)
         end)
  end

  # def list_permutations(list) when is_list(list) do
  #   list
  #     |> Stream.flat_map(fn next ->
  #          Stream.map(list_permutations(list -- [next]), fn(sublist) -> [next | sublist] end)
  #        end)
  # end

  defp debug_indent(string, indentation), do: [String.duplicate("  ", indentation), string]

  # defp cursor_permutations(map, _index, _indentation) when map_size(map) == 0, do: [[]]
  # defp cursor_permutations(map, first_index, debug_level) do
  #   first_index..(map_size(map)-1) |> Stream.flat_map(fn _ ->
  #     {next, submap} = Map.pop(map, first_index)
  #     Logger.debug(debug_indent("inside flat_map", debug_level))
  #     Logger.debug(debug_indent("map: #{inspect(map)}", debug_level))
  #     Logger.debug(debug_indent("index: #{inspect(first_index)}", debug_level))

  #     Stream.map(cursor_permutations(submap, first_index+1, debug_level+1), fn sublist ->
  #       Logger.debug(debug_indent("sublist: #{inspect(sublist)}", debug_level))
  #       [next | sublist]
  #     end)
  #   end)
  # end
end
