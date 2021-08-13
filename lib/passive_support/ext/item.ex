defmodule PassiveSupport.Item do
  @moduledoc """
  Functions for handling arbitrary-shape values.
  """
  @type t :: any
  @type traversable :: tuple | list | map | struct
  @type key_or_index :: atom | integer | String.t

  @doc ~S"""
  Calls `fun.(item)`, returning `item` with any transformations done therein.

  Basically, I got tired of not being able to pipe a value into
  arbitrary positions of other functions.

  ## Examples

      iex> ", " |> Item.tap(&Enum.join(1..10, &1))
      "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"

      iex> false |> Item.tap(&(unless &1, do: "oh!"))
      "oh!"

      iex> [5, 4, 3, 2, 1] |> hd |> Item.tap(&(&1 * &1))
      25

      iex> "hello world!" |> Item.tap(&Regex.scan(~r/lo?/, &1))
      [["l"], ["lo"], ["l"]]
  """
  # @deprecated "Use Kernel.then/2 instead"
  def tap(item, fun), do: fun.(item)

  @doc """
  Calls `fun.(item)` and returns `item` unaltered.

  This function mimics the `tee` program in shell systems,
  allowing a copy of the passed-in item to be sent to another function
  amid a pipeline of other functions that are transforming it
  or handing it off for another value.

  ## Examples

      1..10 |> Enum.to_list |> tee(&Logger.info(inspect(&1, label: "`1..10` as a list")))
      # (… output from Logger …)
      # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

      some_data |> tee(&IO.inspect(&1, label: "encoding as json")) |> Jason.encode!
      # => JSON-encoded data
  """
  # @deprecated "Use Kernel.tap/2 instead"
  def tee(item, fun) do
    fun.(item)
    item
  end

  @doc ~S"""
  Returns `true` for empty enumerables, empty tuples, whitespace-only strings,
  `nil`, and `false`; returns `false` for any other value.

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
      iex> blank?(MapSet.new())
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
      iex> present?(MapSet.new(1..10))
      true
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
  Returns the value for any `present?/1` value and `nil` for any `blank?/1` value.

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
  Traverses into `item` through an arbitrary `path` of keys and indices.

  Think of `dig/3` as an extension of the concept at the heart of
  `Access.get/3`. There are times when the data you're working with
  is a deeply-nested structure, and your bigger concern is what a
  specific part of that data looks like. In cases where you are working
  with one sort of data type (e.g., maps, structs, tuples, or lists),
  then you know you can use the same function or macro to dig down
  through each successive layer of nested data. However, when working
  with disparate data types, keeping track of the structure of each
  level of the nested data becomes an exercise in both patience,
  and trial and error.

  The assurance `dig/3` provides is that, until arriving at a leaf node
  within `item` or fully traversing through `path`, the function will
  retrieve the element of `item` at the next point within `path`,
  dispatching to the correct function for doing so based on the
  structure of the data at the current level of traversal. If `dig`
  arrives at a `nil` value at any point in traversal, the remainder
  of the path is dropped, and the value provided as `default` (which,
  by custom, defaults to `nil` itself) is immediately returned to the
  caller.

  **Note:** The only event in which this function will raise an exception
  is when it attempts to traverse the `path` of a scalar value. To guarantee
  consistency in the traversal rules, trying to traverse a tuple with
  an out-of-bounds index results in `nil` being returned instead of an
  `ArgumentError` being raised. Similarly, attempting to dig into a
  struct at a keyword that it doesn't define will return `nil` instead of
  raising a `KeyError`. For exception propagation, use `dig!/3` instead.

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

  You can also use `dig` through lists of nested data structures
  by passing an empty list `[]` as a part of `path`.

      iex> connor_family = [
      ...>  {"Sarah", %{favorite_movies: ["Dr. Strangelove", "China Town", "Citizen Kane"]}},
      ...>  {"John", %{favorite_movies: ["Tron", "Star Wars", "The Fifth Element"]}},
      ...>  {"Cameron", %{favorite_movies: ["Robocop", "Logan's Run", "The Animatrix - The Second Renaissance Part 2"]}}
      ...> ]
      iex> dig(connor_family, [[], 1, :favorite_movies, 2])
      ["Citizen Kane", "The Fifth Element", "The Animatrix - The Second Renaissance Part 2"]
  """
  @spec dig(traversable, key_or_index | [key_or_index], t) :: t

  def dig(item, path \\ [], default \\ nil)
  def dig(item, path, default) when not is_list(path), do: dig(item, [path], default)
  def dig(item, path, default) do
    try do
      dig_on(item, path, default)
    rescue
      ArgumentError -> default
    end
  end

  defp dig_on(nil, _path, default), do: default
  defp dig_on(item, [], _default), do: item
  defp dig_on(item, [[] | path], default), do: Enum.map(item, &dig_on(&1, path, default))
  defp dig_on(item, path, default) when is_struct(item), do: dig_on(Map.from_struct(item), path, default)
  defp dig_on(item, [next | path], default) when is_map(item), do: dig_on(item[next], path, default)
  defp dig_on(item, [next | path], default) when is_list(item) and is_atom(next),
    do: dig_on(item[next], path, default)
  defp dig_on(item, [next | path], default) when is_list(item) and is_integer(next),
    do: item
     |> Enum.at(next)
     |> dig_on(path, default)
  defp dig_on(item, [next | path], default) when is_tuple(item) and is_integer(next),
    do: item
     |> elem(next)
     |> dig_on(path, default)
end


defprotocol PassiveSupport.Blank do
  @moduledoc ~S"""
  Protocol enabling the `PassiveSupport.Item` functions `blank?/1`, `present?/1`, and `presence/1`.

  To ensure those functions behave properly with your own structs, simply define how they implement
  `PassiveSupport.Blank.blank?/1`. For instance, the implementation for strings is:

  ```elixir
  defimpl PassiveSupport.Blank, for: BitString do
    def blank?(<<>>), do: true
    def blank?(""<>string),
      do: String.match?(string, ~r/\A[[:space:]]*\z/u)
  end
  ```
  """

  @fallback_to_any true

  @spec blank?(Item.t) :: boolean
  def blank?(item)
end

defimpl PassiveSupport.Blank, for: BitString do
  @spec blank?(binary) :: boolean
  def blank?(<<>>), do: true
  def blank?(""<>string),
    do: String.match?(string, ~r/\A[[:space:]]*\z/u)
end

defimpl PassiveSupport.Blank, for: Map do
  @spec blank?(Map.t) :: boolean
  def blank?(map), do:
    map == %{}
end

defimpl PassiveSupport.Blank, for: Tuple do
  @spec blank?(tuple) :: boolean
  def blank?(tuple),
    do: tuple == {}
end

defimpl PassiveSupport.Blank, for: List do
  @spec blank?(list) :: boolean
  def blank?(list),
    do: list == []
end

defimpl PassiveSupport.Blank, for: MapSet do
  @spec blank?(MapSet.t) :: boolean
  def blank?(set), do: Enum.empty?(set)
end

defimpl PassiveSupport.Blank, for: Any do
  @spec blank?(any) :: boolean

  def blank?(item) when is_struct(item),
    do: item
     |> Map.from_struct
     |> Map.values
     |> Enum.all?(&PassiveSupport.Item.blank?/1)

  def blank?(item),
    do: if Enumerable.impl_for(item),
      do: Enum.empty?(item),
      else: !item
end
