defmodule PassiveSupport.Map do

  @doc ~S"""
  Returns a version of `map` whose keys have all been
  converted to strings.

  ## Examples

      iex> PassiveSupport.Map.stringify_keys(%{7 => 8, "hey" => "ha", hi: "ho"})
      %{"7" => 8, "hey" => "ha", "hi" => "ho"}
  """
  def stringify_keys(%{} = map), do:
    map
      |> Stream.map(fn {key, value} -> {to_string(key), value} end)
      |> Enum.into(%{})
end
