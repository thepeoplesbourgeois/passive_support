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
  """
  @spec permutations([any]) :: [[any]]
  def permutations(enum), do: PassiveSupport.Stream.permutations(enum) |> Enum.to_list
end
