defmodule PassiveSupport.Stream do
	alias PassiveSupport.Enum, as: PE

  @doc ~S"""
  Generates a stream of all possible permutations of the given list.

  ## Examples

      iex> 1..50 |> Ps.Stream.permutations |> Enum.take(2)
      [
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         31,32,33,34,35,36,37,38,39,40,
         41,42,43,44,45,46,47,48,49,50],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
         11,12,13,14,15,16,17,18,19,20,
         21,22,23,24,25,26,27,28,29,30,
         31,32,33,34,35,36,37,38,39,40,
         41,42,43,44,45,46,47,48,50,49]
      ]
  """
	@spec permutations([any]) :: Stream.t
	def permutations(enum)

	def permutations(enum) do
    enum
      |> PE.to_map # necessary for fast access
      |> make_permutations
  end

  defp make_permutations(enum) do
    enum
      |> borken_permutations(0)
      # |> cursor_permutations(0, 0)
      # |> list_permutations
  end

	require Logger
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
