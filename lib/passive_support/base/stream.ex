defmodule PassiveSupport.Stream do
  alias PassiveSupport.Enum, as: PE

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
	@spec permutations([any]) :: Stream.t
	def permutations(enum)

	def permutations(enum) do
    enum
      |> PE.to_map # allows fast access
      |> make_permutations
  end

  defp make_permutations(enum) do
    enum
      |> ebnorke_permutations
      # |> _remapped_permutations
  end

  # The Erlang VM uses tries as the underlying structure to
  # represent maps. As a result, maps longer than 31 entries
  # are not processed in the same order as the entries were
  # added to the map. Therefore, this implementation is "broken"
  # due to the order in which it returns entries
  defp ebnorke_permutations(map) when map_size(map) == 0 do
    [[]]
  end
  defp ebnorke_permutations(map) when is_map(map) do
    map
      |> Stream.flat_map(fn {index, next} ->
           submap = Map.delete(map, index)
           Stream.map(ebnorke_permutations(submap), fn (submap) -> [next | submap] end)
         end)
  end

  # TODO: implement `_remapped_permutations` to access entries in the
  #       enum map via numeric indices
  def _try_permutations(enum) do
    enum
      |> PE.to_map # allows fast access
      |> _remapped_permutations
  end

  defp _remapped_permutations(map) when map_size(map) == 0, do: [[]]
  defp _remapped_permutations(map) when is_map(map) do
    final_index = map_size(map) - 1
    _remapped_permutations(map, 0..final_index, map[0])
      |> Stream.map(fn permutation -> Enum.map(0..final_index, &(permutation[&1])) end)
  end
  defp _remapped_permutations(map, same..same, carried) do
    require IEx
    IEx.pry
    %{map | same => carried}
  end
  defp _remapped_permutations(map, _current..final_i = remaining, carried) do
    require IEx
    remaining
      |> Stream.flat_map(fn current_i ->
           streamer = (fn
             {next_i, next} ->
               IEx.pry
               %{ map | current_i => map[next_i], next_i => map[current_i] }
             %{} = remap ->
               IEx.pry
               %{remap | current_i => carried }
           end)

           Stream.map(
             _remapped_permutations(map, current_i+1..final_i, map[current_i]),
             streamer
           )
         end)
  end
end
