defmodule PassiveSupport.Enum do
  @doc """
  Initiates a `Task` for each item in the enumerable,
  invoking the provided function, then awaits and returns the processed list.
  """
  @spec async_map(Enum.t, function) :: Enum.t
  def async_map(enum, func), do:
    Task.async_stream(enum, func)
      |> Enum.map(fn {:ok, result} -> result end)

end
