defmodule PassiveSupport.Atom do

  @doc """
  Returns true if the passed-in value resembles an existing atom
  and false if it does not.

  ## Examples

      iex> Ps.Atom.exists?(:foo)
      true
      iex> Ps.Atom.exists?("yes")
      true
      iex> Ps.Atom.exists?("bar")
      false
  """
  def exists?(atom) when is_atom(atom), do: true
  def exists?(string) when is_binary(string) do
    try do
      String.to_existing_atom(string) && true
    rescue
      ArgumentError -> false
    end
  end
end
