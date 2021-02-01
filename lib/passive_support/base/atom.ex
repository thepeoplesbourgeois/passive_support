defmodule PassiveSupport.Atom do

  @doc """
  Returns true if the passed-in value resembles an existing atom
  and false if it does not.

  ## Examples

      iex> exists?(:foo)
      true
      iex> exists?("yes")
      true
      iex> exists?("bar")
      false
  """
  def exists?(atom) when is_atom(atom), do: true
  def exists?(string) when is_binary(string) do
    String.to_existing_atom(string) && true
  rescue
    ArgumentError -> false
  end
end
