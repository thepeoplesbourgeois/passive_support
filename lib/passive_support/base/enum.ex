defmodule PassiveSupport.Enum do
  @doc """
  Counts the number of items in the given enumerable.

  Has runtime complexity of O(n), like `Kernel.length/1`, but can be invoked
  on any structure that implements the `Enumerable` protocol.

  ## Examples

      iex> Ps.Enum.length([1,2,nil])
      3

      iex> Ps.Enum.length(%{oh: :hi})
      1
  """
  @spec length(Enum.t) :: integer
  def length(enum), do:
    Enum.reduce(enum, 0, fn (_item, enum_length) -> enum_length+1 end)

  @doc """
  Initiates a `Task` for each element in the enumerable,
  invoking the provided function, then awaits and returns the processed list.

  Implementation taken from http://elixir-recipes.github.io/concurrency/parallel-map/
  """
  @spec async_map(Enum.t, function) :: Enum.t
  def async_map(enum, func), do:
    enum
      |> Enum.map(&(Task.async(fn -> func.(&1) end)))
      |> Enum.map(&Task.await/1)

end