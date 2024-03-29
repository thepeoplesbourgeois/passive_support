defmodule PassiveSupport.Atom do
  @moduledoc """
  Functions for working with atoms and strings which may reference atoms
  """

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
  @spec exists?(String.t | atom) :: boolean
  def exists?(atom) when is_atom(atom), do: true
  def exists?(string) when is_binary(string) do
    case safe_existing_atom(string) do
      {:ok, _} -> true
      :error -> false
    end
  end

  @doc """
  If able, casts the string to an existing atom, returning `nil` if not.

  Also passes atoms through, for convenience.

  ## Examples

      iex> from_string("ok")
      :ok

      iex> from_string("error")
      :error

      iex> from_string("true")
      true

      iex> from_string("false")
      false

      iex> from_string("nil") # `nil` is, itself, an atom
      nil

      iex> from_string("what's all this then?")
      nil

      iex> from_string(:foo)
      :foo
  """
  @spec from_string(String.t | atom) :: atom | nil
  def from_string(atomish) when is_atom(atomish), do: atomish
  def from_string("" <> atomish) do
    case safe_existing_atom(atomish) do
      {:ok, atom} -> atom
      _ -> nil
    end
  end
end
