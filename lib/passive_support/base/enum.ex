defmodule PassiveSupport.Enum do
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