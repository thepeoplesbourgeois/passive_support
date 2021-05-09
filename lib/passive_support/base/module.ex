defmodule PassiveSupport.Module do
  @moduledoc """
    Convenience functions and helpers for module introspection
  """

  @doc """
    For a `module` and `export`, returns either `nil` or a tuple describing the export.

    This function does not retrieve private function or macro arities,
    as its intended use case is for dynamically finding if a given function
    or macro can be called upon within a given module, and if so, with how many
    arguments.

    ## Examples

        iex> check_for_export(String, :trim)
        {:function, [1, 2]}

        iex> check_for_export(PassiveSupport.Path.Sigil, :sigil_P)
        {:macro, [2]}

        iex> check_for_export(Integer, :possibly_private_but_equally_likely_not_to_exist)
        nil
  """
  def check_for_export(module, export) do
    filter = &Enum.filter(&1, fn {call, _} -> call == export end)

    with {:function, []} <- {:function, filter.(module.__info__(:functions))},
         {:macro, []} <- {:macro, filter.(module.__info__(:macros))}
    do
      nil
    else
      {:function, arities} ->
        {:function, Keyword.values(arities)}
      {:macro, arities} ->
        {:macro, Keyword.values(arities)}
    end
  end
end
