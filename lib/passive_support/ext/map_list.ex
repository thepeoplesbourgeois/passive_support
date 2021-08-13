defmodule MapList do
  @moduledoc """
  **This moduledoc is provided to give insight into the
  ideal working shape of the MapList. It is not yet implemented.
  There's literally nothing to see here as of now, besides this,
  what is very possibly the first ever recorded instance
  of technical documentation fiction.**

  Functions for interacting with a list of data in an indexed
  manner. Because `Map`s are not a lightweight structure, this
  module is recommended for edge cases in which normal traversal
  of a `List` would otherwise be too time inefficient for frequent
  tasks.

  MapLists are implemented to behave as a `List` in almost all
  cases. The notable exception being that a `MapList` provides a
  tuple of `{index, item}` to its implementation of `Enumerable`,
  and always returns a `MapList` for further transformation. To
  get the list of items from a `MapList`, use `MapList.values/1`.
  You can also call `MapList.to_list/1` to get a list of the
  `{index, item}` pairs.

      iex> MapList.new(["Hello","elixir","world!"])
      %MapList["Hello", "elixir", "world!"]

  Since MapLists can't be destructured, functions are provided to
  apply transformations to them. Adding elements to either the
  head or the tail of a MapList can be done quickly, as indices
  will not need to be internally recalculated in these operations.

      iex> map_list = MapList.push(MapList.new([1,2,3,4]), 5)
      %MapList[1, 2, 3, 4, 5]
      iex> map_list = MapList.unshift(map_list, 0)
      %MapList[0, 1, 2, 3, 4, 5]

  Removing elements from the head or tail is similarly fast.

      iex> map_list = MapList.new(1..10)
      %MapList[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
      iex> {last, map_list} = MapList.pop(map_list)
      {10, %MapList[1, 2, 3, 4, 5, 6, 7, 8, 9]}
      iex> {first, map_list} = MapList.shift
      {1, %MapList[2, 3, 4, 5, 6, 7, 8, 9]}

  Replacing an element in the middle of the MapList is similarly
  uncostly, but inserting or removing an element from the middle
  of a MapList will cause the indices to be internally recalculated,
  to avoid requiring to traverse and ignore a sentinel value
  (or stop at the sentinel value, as parts of the `:array` module do).

      iex> map_list = MapList.new(~W"Hello elixir world!")
      ...>  |> MapList.insert_at(1, "brave")
      %MapList["Hello", "brave", "elixir", "world!"]
      iex> map_list
      ...>  |> MapList.replace_at(1, "awesome")
      %MapList["Hello", "awesome", "elixir", "world!"]
  """

  @moduledoc false
end
