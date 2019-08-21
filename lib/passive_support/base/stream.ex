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
      # |> remapped_permutations
  end

  # The Erlang VM uses tries as the underlying structure for
  # representing maps. As a result, maps containing more than
  # 31 entries are not enumerated through in the same order
  # as the entries were added to the map.
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

  # TODO: implement `remapped_permutations` to access the enum map via numeric indices
  def _try_permutations(enum) do
    enum
      |> PE.to_map # allows fast access
      |> remapped_permutations
  end

  # """
  # remapped_permutations(%{0 => 1, 1 => 2, 2 => 3})
  # [
  #   %{0 => 1, 1 => 2, 2 => 3},
  #   %{0 => 1, 1 => 3, 2 => 2},
  #   %{0 => 2, 1 => 1, 2 => 3},
  #   %{0 => 2, 1 => 3, 2 => 1},
  #   %{0 => 3, 1 => 1, 2 => 2},
  #   %{0 => 3, 1 => 2, 2 => 1}
  # ]
  # """

  defp remapped_permutations(map) when map_size(map) == 0, do: [[]]
  defp remapped_permutations(map) when is_map(map) do
    final_index = map_size(map) - 1
    remapped_permutations(map, 0..final_index, map[0])
      |> Stream.map(fn permutation -> Enum.map(0..final_index, &(permutation[&1])) end)
  end
  require IEx
  defp remapped_permutations(map, same..same, carried) do
    IEx.pry
    %{map | same => carried}
  end
  defp remapped_permutations(map, _current..final_i = remaining, carried) do
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
             remapped_permutations(map, current_i+1..final_i, map[current_i]),
             streamer
           )
         end)
  end


  # map
  #   |> Stream.flat_map(fn
  #     {0, next} ->
  #       Stream.map(1..final, fn other_index ->
  #         %{ map | other_index => next,
  #             0 => map[other_index]
  #         }
  #       end)
  #     {^final, next} ->
  #       Stream.map(0..(final-1), fn other_index ->
  #         %{ map | other_index => next,
  #             final => map[other_index]
  #         }
  #       end)
  #     {index, next} ->
  #       Stream.concat(0..(index-1), (index+1)..final)
  #         |> Stream.map(fn other_index ->
  #           %{ map | other_index => next,
  #               index => map[other_index]
  #           } end)
  #   end)

  # def list_permutations(list) when is_list(list) do
  #   list
  #     |> Stream.flat_map(fn next ->
  #          Stream.map(list_permutations(list -- [next]), fn(sublist) -> [next | sublist] end)
  #        end)
  # end

  defp _debug_indent(string, indentation), do: [String.duplicate("  ", indentation), string]

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
