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
  @spec check_for_export(atom, atom) :: {:function | :macro, [non_neg_integer()]} | nil
  def check_for_export(module, export_type) do
    filter = &Enum.filter(&1, fn {callable_type, _} -> callable_type == export_type end)

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

  @doc """
  Retrieves an alias with the same name as `string` if the alias was already referenced.

  Returns `nil` if the alias has not already been referenced.

  ## Examples

      iex> from_string("PassiveSupport.Module")
      PassiveSupport.Module

      iex> from_string("PassiveSupport.Nodule")
      nil
  """
  @spec from_string(String.t) :: atom | nil
  def from_string(string) do
    try do
      Module.safe_concat([string])
    rescue _ ->
      nil
    end
  end
end
