defmodule PassiveSupport.Item do
  @moduledoc """
  Functions for handling arbitrary-shape values.
  """

  @type t :: any
  @doc ~S"""
    Returns `true` of any value that would return `true` with `Enum.empty?/1`,
    as well as to bare tuples, binaries with no data, and strings containing
    only whitespace, `nil`, and `false`. Returns `false` for any other value.

    Note that while a string containing only whitespace can be considered blank,
    a charlist of the same nature will return `false`. Because charlists are
    represented internally as lists of integers, a charlist of whitespace would
    be indescernible from a list of numeric integers, neither of which would be
    individually considered blank, and therefore should not be regarded as blank
    in tandem.

    ## Examples

        iex> blank?({})
        true
        iex> blank?(%{})
        true
        iex> blank?(%MapSet{})
        true
        iex> blank?(0)
        false
        iex> blank?(nil)
        true
        iex> blank?(false)
        true
        iex> blank?("  ")
        true
        iex> blank?('  ') # [32, 32]
        false
        iex> blank?(" hi ")
        false
    """
  @spec blank?(t) :: boolean
  def blank?(item), do:
    PassiveSupport.Blank.blank?(item)

  @doc ~S"""
    Returns `true` of any value that is not `blank?/1`

    ## Examples

        iex> present?({})
        false
        iex> present?(%{})
        false
        iex> present?(%MapSet{})
        false
        iex> present?(0)
        true
        iex> present?(nil)
        false
        iex> present?(false)
        false
        iex> present?("  ")
        false
        iex> present?(' ')
        true
        iex> present?(" hi ")
        true
    """
  @spec present?(t) :: boolean
  def present?(item), do:
    !blank?(item)

  @doc ~S"""
    Returns `nil` for any `blank?/1` value, and returns the value back otherwise.

    ## Examples

        iex> presence({})
        nil
        iex> presence(%{})
        nil
        iex> presence(nil)
        nil
        iex> presence(false)
        nil
        iex> presence([false])
        [false]
        iex> presence("  ")
        nil
        iex> presence(" hi ")
        " hi "
    """
  @spec presence(t) :: t | none
  def presence(item), do:
    if present?(item), do: item, else: nil

  @doc """
    Traverses into `item` through an arbitrary `path` of keys and indices

    ## Examples

        iex> pets = %{
        ...>   cats: [
        ...>     %{name: "Lester", favorite_toy: "feather"},
        ...>     %{name: "Janice", favorite_toy: "laser pointer"}
        ...>   ],
        ...>   dogs: [
        ...>     %{name: "Scrump", favorite_toy: "rope"},
        ...>     %{name: "Stitch", favorite_toy: "ball"}
        ...>   ],
        ...>   hyenas: [
        ...>     %{"what is this" => "oh no", "hyenas can't be pets" => "too wild"}
        ...>   ]
        ...> }
        iex> dig(pets, [:dogs])
        [%{name: "Scrump", favorite_toy: "rope"}, %{name: "Stitch", favorite_toy: "ball"}]
        iex> dig(pets, [:cats, 1])
        %{name: "Janice", favorite_toy: "laser pointer"}
        iex> dig(pets, [:hyenas, 0, "what is this"])
        "oh no"
        iex> dig(pets, [:dogs, 0, :favorite_food, :ingredients])
        nil
    """
  @spec dig(t, [atom | integer | String.t]) :: t
  def dig(item, path \\ []) do
    dig_on(item, path)
  end

  defp dig_on(nil, _), do: nil
  defp dig_on(item, []), do: item
  defp dig_on(item, [next | path]) when is_atom(next), do: dig_on(item[next], path)
  defp dig_on(item, [next | path]) when is_binary(next), do: dig_on(item[next], path)
  defp dig_on(item, [next | path]) when is_integer(next) and is_list(item),
    do: item
     |> List.pop_at(next)
     |> elem(0)
     |> dig_on(path)
  defp dig_on(item, [next | path]) when is_integer(next) and is_tuple(item),
    do: item
     |> elem(next)
     |> dig_on(path)
end


defprotocol PassiveSupport.Blank do
  @fallback_to_any true

  @spec blank?(Item.t) :: boolean
  def blank?(item)
end

defimpl PassiveSupport.Blank, for: BitString do
  @spec blank?(binary) :: boolean
  def blank?(<<>>), do:
    true
  def blank?(""<>string), do:
    String.match?(string, ~r/\A[[:space:]]*\z/u)
end

defimpl PassiveSupport.Blank, for: Map do
  @spec blank?(Map.t) :: boolean
  def blank?(map), do:
    map == %{}
end

defimpl PassiveSupport.Blank, for: Tuple do
  @spec blank?(tuple) :: boolean
  def blank?(tuple), do:
    tuple == {}
end

defimpl PassiveSupport.Blank, for: List do
  @spec blank?(list) :: boolean
  def blank?(list), do:
    list == []
end

defimpl PassiveSupport.Blank, for: Any do
  @spec blank?(any) :: boolean
  def blank?(%MapSet{}), do:
    true

  def blank?(item) when is_map(item), do:
    item
      |> Map.from_struct
      |> Map.values
      |> Enum.all?(&PassiveSupport.Item.blank?/1)

  def blank?(item), do:
    if Enumerable.impl_for(item), do: Enum.empty?(item), else: !item
end
