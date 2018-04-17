defmodule PassiveSupport.Enum do
  @doc """
  Concurrently runs `func` on each item in the enumerable

  ## Examples

      iex> Ps.Enum.async_map(1..11, &(&1 * &1))
      [1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121]
  """
  @spec async_map(Enum.t, function) :: Enum.t
  def async_map(enum, func), do:
    Task.async_stream(enum, func)
      |> Enum.map(fn {:ok, result} -> result end)

end
