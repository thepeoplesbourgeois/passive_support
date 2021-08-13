defmodule PassiveSupport.Stream do
  import PassiveSupport.Enum, only: [to_map: 1]

  @doc """
  Processes an item while iterating through the provided stream

  `PassiveSupport.Stream.with_memo/3` attaches an arbitrary accumulator
  `acc` to the provided `enum`, and transforms it in relation to each
  successive item in the enumerable according to the return of `fun.(item, acc)`.

  Think of it like `Stream.with_index/2`, but with the abstracted versatility
  of `Enum.reduce/3`.

  In fact, implementing `Stream.with_index/2` is possible with `PassiveSupport.Stream.with_memo/3`

      iex> with_index = fn enum ->
      ...>   with_memo(enum, -1, fn _el, ix -> ix+1 end)
      ...> end
      iex> String.graphemes("hi world!") |> with_index.() |> Enum.to_list
      [{"h", 0}, {"i", 1}, {" ", 2},
       {"w", 3}, {"o", 4}, {"r", 5}, {"l", 6}, {"d", 7}, {"!", 8}
      ]

  By passing `false` as a fourth argument, `evaluate_first`, you can return
  `accumulator` in the state it was in prior to `fun` being called.

      iex> with_memo(?a..?c, "", fn char, string -> string <> to_string([char]) end) |> Enum.to_list
      [
        {97, "a"},
        {98, "ab"},
        {99, "abc"}
      ]

      iex> with_memo(?a..?c, "", fn char, string -> string <> to_string([char]) end, false) |> Enum.to_list
      [
        {97, ""},
        {98, "a"},
        {99, "ab"}
      ]
  """
  @spec with_memo(Enumerable.t, any, (Stream.element(), Stream.acc() -> Stream.acc()), boolean) :: Enumerable.t
  def with_memo(enum, accumulator, fun, evaluate_first \\ true) do
    Stream.transform(enum, accumulator, fn item, acc ->
      new = fun.(item, acc)
      {[{item, if(evaluate_first, do: new, else: acc)}],
        new
      }
    end)
  end

  @doc """
  Generates a stream of all possible permutations of the given list.

  Note: The permutations of enumerables containing 32 items or more
  will not come back in exactly the order you might expect if you are
  familiar with the general permutation algorithm. This is because
  PassiveSupport first renders the enumerable into a map, with keys
  representing each item's index from the list form of the enumerable.
  The Erlang VM uses a keyword list to represent maps of 31 and fewer
  items,and a data structure called a trie to represent maps larger
  than that. Because of how Erlang enumerates the key-value pairs of this
  trie, the order in which those pairs are presented is not in incrementing order.

  That said, the order _is_ still deterministic, all permutations
  of the enumerable will be available by the time the stream is done
  being processed, and this function scales far more effectively
  by generating permutations out of this intermediary map than it would
  by generating them out of the equivalent list.

  ## Examples

      iex> 1..4 |> permutations |> Enum.take(16)
      [
        [1, 2, 3, 4],
        [1, 2, 4, 3],
        [1, 3, 2, 4],
        [1, 3, 4, 2],
        [1, 4, 2, 3],
        [1, 4, 3, 2],
        [2, 1, 3, 4],
        [2, 1, 4, 3],
        [2, 3, 1, 4],
        [2, 3, 4, 1],
        [2, 4, 1, 3],
        [2, 4, 3, 1],
        [3, 1, 2, 4],
        [3, 1, 4, 2],
        [3, 2, 1, 4],
        [3, 2, 4, 1]
      ]

      iex> 1..50 |> permutations |> Enum.take(2)
      [
        [
          34, 13, 45, 24, 30, 48, 31, 44, 40, 46,
          49, 27, 47, 32, 12, 38, 10, 33, 1, 2, 3,
          4, 5, 6, 7, 8, 9, 11, 14, 15, 16, 17, 18,
          19, 20, 21, 22, 23, 25, 26, 28, 29, 35,
          36, 37, 39, 41, 42, 43, 50
        ],
        [
          34, 13, 45, 24, 30, 48, 31, 44, 40, 46,
          49, 27, 47, 32, 12, 38, 10, 33, 1, 2, 3,
          4, 5, 6, 7, 8, 9, 11, 14, 15, 16, 17, 18,
          19, 20, 21, 22, 23, 25, 26, 28, 29, 35,
          36, 37, 39, 41, 42, 50, 43
        ]
      ]
  """
  @spec permutations(Enumerable.t) :: Stream.t
  def permutations(enumerable)
  def permutations(enumerable) do
    enumerable
     |> to_map # allows fast access
     |> make_permutations
  end

  defp make_permutations(map) when map_size(map) == 0 do
    [[]]
  end
  defp make_permutations(map) when is_map(map),
    do: map
     |> Stream.flat_map(fn {index, next} ->
          submap = map
           |> Map.delete(index)
          Stream.map(make_permutations(submap), fn (sub) -> [next | sub] end)
        end)
end
