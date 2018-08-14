defmodule PassiveSupport.List do
  require Logger
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

end
