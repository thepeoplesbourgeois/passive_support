defmodule PassiveSupport.List do
  require Logger

  @doc ~S"""
  Returns a new list of `[item | list]`
  An antonym to `hd`.

  ## Examples

      iex> cons([2,3], 1)
      [1,2,3]
      iex> [2,3] |> cons(1) |> cons(0)
      [0,1,2,3]
  """
  @spec cons(list, any()) :: list
  def cons(list, item)
  def cons(list, item) when is_list(list), do:
    [item | list]

  @doc ~S"""
  Returns a copy of `list` with any `nil` values removed

  ## Examples

      iex> compact([1,nil,3])
      [1, 3]

      iex> compact([false, nil, nil, "hi"])
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

      iex> compact_map([1,2,nil,4], &(&1 * 2))
      [2,4,8]

      iex> compact_map([nil, "   ", {}, 0], &PassiveSupport.Item.presence/1, also_filter_result: true)
      [0]

      iex> compact_map([nil, false, 0], &(&1), also_filter_result: true)
      [false, 0]
  """
  @spec compact_map(list, fun, [also_filter_result: boolean]) :: list
  def compact_map(list, fun, options \\ [])
  def compact_map([], _fun, _options), do:
    []
  def compact_map([nil|tail], fun, options), do:
    compact_map(tail, fun, options)
  def compact_map([head|tail], fun, also_filter_result: true), do:
    if ((result = fun.(head)) != nil),
      do: [result | compact_map(tail, fun, also_filter_result: true)],
      else: compact_map(tail, fun, also_filter_result: true)
  def compact_map([head|tail], fun, options), do:
    [fun.(head) | compact_map(tail, fun, options)]

end
