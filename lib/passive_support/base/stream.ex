defmodule PassiveSupport.Stream do
  import PassiveSupport.Enum, only: [to_map: 1]

  @doc """
  Attaches an accumulator, `acc`, to each element of the enumerable,
  whose value changes per element, as defined by the return of `fun`.

  Think of it like `Stream.with_index/2`, except abstracted in a manner
  that provides the versatility of `Enum.reduce/3`

      iex> with_memo(?a..?h, "", fn el, acc -> acc <> to_string([el]) end) |> Enum.to_list
      [
        {97, "a"},
        {98, "ab"},
        {99, "abc"},
        {100, "abcd"},
        {101, "abcde"},
        {102, "abcdef"},
        {103, "abcdefg"},
        {104, "abcdefgh"},
      ]

  In fact, implementing `Stream.with_index/2` is possible with `PassiveSupport.Stream.with_memo/3`

      iex> with_index = fn enum -> with_memo(enum, -1, fn _el, ix -> ix+1 end) end
      iex> String.codepoints("hello world!") |> with_index.() |> Enum.to_list
      [
        {"h", 0},
        {"e", 1},
        {"l", 2},
        {"l", 3},
        {"o", 4},
        {" ", 5},
        {"w", 6},
        {"o", 7},
        {"r", 8},
        {"l", 9},
        {"d", 10},
        {"!", 11}
      ]
  """
  def with_memo(enum, accumulator, fun) do
    Stream.transform(enum, accumulator, fn el, acc ->
      acc = fun.(el, acc)
      {[{el, acc}], acc}
    end)
  end

  @doc """
  Generates a stream of all possible permutations of the given list.
  Note: due to the internal structure of maps in the Erlang VM, enumerables
  of lengths greater than 32 will not have permutations returned in the
  expected ordering, but will be returned in a deterministic order, and
  the full list of permutations will be available for iteration

  ## Examples

      iex> 1..32 |> permutations |> Enum.take(2)
      [
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         31,32],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         32,31]
      ]
  """
	@spec permutations(Enumerable.t) :: Stream.t
	def permutations(enumerable)
	def permutations(enumerable) do
    enumerable
      |> to_map # allows fast access
      |> make_permutations
  end

  defp make_permutations(enumerable) do
    enumerable
      |> ebnorke_permutations
  end

  # The Erlang VM uses tries as the underlying structure to
    # represent maps. As a result, maps longer than 31 entries
    # are not processed in the same order as the entries were
    # added to the map. Therefore, this implementation is "broken"
    # in terms of the ordering of returned entries vs. passed-in
  defp ebnorke_permutations(map) when map_size(map) == 0 do
    [[]]
  end
  defp ebnorke_permutations(map) when is_map(map),
    do: map
     |> Stream.flat_map(fn {index, next} ->
          submap = map
           |> Map.delete(index)
          Stream.map(ebnorke_permutations(submap), fn (sub) -> [next | sub] end)
        end)
end
