defmodule PassiveSupport.Stream do
  import PassiveSupport.Enum, only: [to_map: 1]

  @doc ~S"""
  Generates a stream of all possible permutations of the given list.
  Note: due to the internal structure of maps in the Erlang VM, enumerables
  of lengths greater than 32 will not have permutations returned in the
  expected ordering, but will be returned in a deterministic order, and
  the full list of permutations will be available for iteration

  ## Examples

      iex> 1..32 |> Ps.Stream.permutations |> Enum.take(2)
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
	def permutations(enum)

	def permutations(enum) do
    enum
      |> to_map # allows fast access
      |> make_permutations
  end

  defp make_permutations(enum) do
    enum
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
