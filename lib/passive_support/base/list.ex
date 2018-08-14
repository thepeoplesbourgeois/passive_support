defmodule PassiveSupport.List do
  alias PassiveSupport, as: Ps

  @doc ~S"""
  Returns a copy of `list` with any `nil` values removed

  ## Examples

      iex> Ps.List.compact([1,nil,3])
      [1, 3]

      iex> Ps.List.compact([false, nil, nil, "hi"])
      [false, "hi"]
  """
  @spec compact(list) :: list
  def compact([]), do:
    []
  def compact([nil | tail]), do:
    compact(tail)
  def compact([head | tail]), do:
    [head | compact(tail)]

  @doc ~S"""
  Performs the provided function on every non-nil value while removing nil values.
  If `also_filter_result` is passed, then any nil values that would be returned
  from the function are not injected into the list.

  ## Examples

      iex> Ps.List.compact_map([1,2,nil,4], &(&1 * 2))
      [2,4,8]

      iex> Ps.List.compact_map([nil, "   ", {}, 0], &Ps.Item.presence/1, also_filter_result: true)
      [0]

      iex> Ps.List.compact_map([nil, false, 0], &(&1), also_filter_result: true)
      [false, 0]
  """
  @spec compact_map(list, fun, [also_filter_result: boolean]) :: list
  def compact_map(list, fun, options \\ [])
  def compact_map([], _fun, _options), do:
    []
  def compact_map([nil|tail], fun, options), do:
    compact_map(tail, fun, options)
  def compact_map([head|tail], fun, also_filter_result: true) do
    result = fun.(head)
    if (result != nil), do: [result | compact_map(tail, fun, also_filter_result: true)], else: compact_map(tail, fun, also_filter_result: true)
  end
  def compact_map([head|tail], fun, options), do:
    [fun.(head) | compact_map(tail, fun, options)]


  @doc ~S"""
  Generates a list of all possible permutations of the given list.
  If `stream: true` is passed,

  ## Examples

      iex> Ps.List.permutations([1,2,3])
      [
        [1, 2, 3],
        [1, 3, 2],
        [2, 1, 3],
        [2, 3, 1],
        [3, 1, 2],
        [3, 2, 1]
      ]
  """
  # iex> 1..50 |> Enum.to_list |> Ps.List.permutations(stream: true) |> Enum.take(1)
  # [
  #   [1,2,3,4,5,6,7,8,9,10,
  #    11,12,13,14,15,16,17,18,19,20,
  #    21,22,23,24,25,26,27,28,29,30,
  #    31,32,33,34,35,36,37,38,39,40,
  #    41,42,43,44,44,46,47,48,49,50]
  # ]


  @spec permutations([any], [stream: boolean()]) :: [[any]] | Stream.t
  def permutations(list, options \\ [])

  def permutations([], _), do: [[]]
  def permutations(list, options) when is_list(list) do
    lazy = list
      |> Ps.Enum.to_map
      |> make_permutations
    if Keyword.get(options, :stream),
      do: lazy,
      else: Enum.to_list(lazy)
  end

  defp make_permutations(list) do
    list
      |> map_permutations(0, 0)
      # |> list_permutations
  end

  def list_permutations(list) when is_list(list) do
    list
      |> Stream.flat_map(fn next ->
           Stream.map(list_permutations(list -- [next]), fn(sublist) -> [next | sublist] end)
         end)
  end

  defp debug_indent(string, indentation), do: [String.duplicate("  ", indentation), string]

  defp map_permutations(map, _index, _indentation) when map_size(map) == 0, do: [[]]
  defp map_permutations(map, first_index, debug_level) do
    first_index..(map_size(map)-1) |> Stream.flat_map(fn _ ->
      {next, submap} = Map.pop(map, first_index)
      IO.puts(debug_indent("inside flat_map", debug_level))
      IO.puts(debug_indent("map: #{inspect(map)}", debug_level))
      IO.puts(debug_indent("index: #{inspect(first_index)}", debug_level))

      Stream.map(map_permutations(submap, first_index+1, debug_level+1), fn sublist ->
        IO.puts(debug_indent("sublist: #{inspect(sublist)}", debug_level))
        [next | sublist]
      end)
    end)
  end

  # @spec map_permutations(%{integer => any()}, integer) :: Stream.t
  # defp map_permutations(map, debug_indentation) do
  #   indent = fn string -> [String.duplicate("  ", debug_indentation*2), string] end
  #   # IO.puts(indent.("inside map_permutations #{debug_indentation}"))
  #   Stream.flat_map(0..map_size(map), fn index ->
  #     # IO.puts(indent.("  next: #{inspect(next)}"))
  #     next = map[index]
  #     Stream.map(
  #       map_permutations(Map.delete(map, index), debug_indentation+1),
  #       fn sublist ->
  #         IO.puts(indent.("  sublist: #{inspect(sublist)}"))
  #         [next | sublist]
  #       end
  #     )
  #   end)
  # end
        # if map_size(submap) in 1..2 do
        #   require IEx
        #   IEx.pry
        # end

        # case map_size(submap) == 0 do
          # true ->
          #     require IEx
          #     IEx.pry
          #   [following | []]
          # false ->
            #   require IEx
            #   IEx.pry
            # [ following | map_permutations(submap, (debug_indentation+1)) ]
        # end
      # end)
      # IO.puts(indent.("  sublist: #{inspect(sublist)}"))
      # [next | sublist]
    # end)
  # end
end
