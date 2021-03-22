defmodule PassiveSupport.Atom do
  import PassiveSupport.String, only: [safe_existing_atom: 1]
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

      iex> exists?("false")
      true

      iex> exists?("nil")
      true
  """
  def exists?(atom) when is_atom(atom), do: true
  def exists?(string) when is_binary(string) do
    String.to_existing_atom(string)
    true
  rescue
    ArgumentError -> false
  end

  @doc """
  If able, casts the string to an atom, returning `nil` if not.

  ## Examples

      iex> from_string("ok")
      :ok

      iex> from_string("error")
      :error

      iex> from_string("true")
      true

      iex> from_string("false")
      false

      iex> from_string("nil")
      nil

      iex> from_string("what's all this then?")
      nil
  """
  @spec from_string(String.t()) :: atom() | nil
  def from_string(atomish) do
    case safe_existing_atom(atomish) do
      {:ok, atom} -> atom
      _ -> nil
    end
  end
end
