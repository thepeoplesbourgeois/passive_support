defmodule PassiveSupport.Map do
  @moduledoc """
  Convenience functions for working with maps.
  """

  alias PassiveSupport.Item

  @type key :: any

  @doc """
  Alters `key` according to `fun` within the given `map`.

  Useful for when you're shuffling values around inside of a map,
  or, I dunno, going through your music collection and you discover
  you accidentally attributed an entire Beatles album to the Monkees.
  Although how you did that is beyond me. You monster.


  """
  @spec change_key(map, key, (key -> key) | ((key, map) -> key)) :: map
  def change_key(map, key, fun) when is_map_key(map, key) and is_function(fun, 1) do
    {value, map} = Map.pop(map, key)
    put_in(map[fun.(key)], value)
  end
  def change_key(map, key, fun) when is_map_key(map, key) and is_function(fun, 2) do
    {value, map} = Map.pop(map, key)
    put_in(map[fun.(key, map)], value)
  end

  @doc ~S"""
  Returns a version of `map` whose keys have all been
  converted to strings.

  ## Examples

      iex> stringify_keys(%{7 => 8, "hey" => "ha", hi: "ho"})
      %{"7" => 8, "hey" => "ha", "hi" => "ho"}
  """
  def stringify_keys(%{} = map),
    do: map
     |> Stream.map(fn {key, value} -> {to_string(key), value} end)
     |> Enum.into(%{})

  @doc ~S"""
  Returns `map` with its keys as atoms, if those atoms already exist.

  Raises `ArgumentError` otherwise.

  ## Examples

      iex> [:oh, :yay] # existing keys
      iex> atomize_keys!(%{"oh" => "ooh", 'yay' => 'yaaay'})
      %{oh: "ooh", yay: 'yaaay'}
      iex> atomize_keys!(%{"oh" => "ooh", "noo" => "noooo"})
      ** (ArgumentError) argument error
  """
  def atomize_keys!(%{} = map),
    do: map
     |> Stream.map(fn {key, value} ->
          atom = key |> to_string |> String.to_existing_atom
          {atom, value}
        end)
     |> Enum.into(%{})

  @doc ~S"""
  Returns a `map` with any string keys that safely coerced to existing atoms

  I'm not giving y'all the ridiculously dangerous footgun of
  wanton atom space pollution. I'm not some crazy, foot-shooting
  cowboy, like `Jason`.

  ## Examples

      iex> [:oh, :yay] # existing keys
      iex> safe_atomize_keys(%{"oh" => "ooh", 'yay' => 'yaaay'})
      %{oh: "ooh", yay: 'yaaay'}
      iex> safe_atomize_keys(%{"oh" => "ooh", "noo" => "noooo"})
      %{oh: "ooh"}
  """
  def safe_atomize_keys(%{} = map),
    do: map
     |> Stream.map(fn {key, value} -> {to_string(key), value} end)
     |> Stream.filter(fn {key, _} -> PassiveSupport.Atom.exists?(key) end)
     |> Stream.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
     |> Enum.into(%{})

  @doc """
  Returns a copy of `map` containing only `keys` and raises
  if any are missing.

  If `keys` are not provided, returns `map` unchanged

  ## Examples

      iex> take!(%{a: "foo", b: 42, c: :ok}, [:b, :c])
      %{b: 42, c: :ok}

      iex> take!(%{a: "foo", b: 42})
      %{a: "foo", b: 42}

      iex> take!(%{"a" => "foo", "b" => 42, "c" => :ok}, ["c", "e"])
      ** (MissingKeysError) Expected to find keys ["c", "e"] but only found keys ["c"]
  """
  @spec take!(map, list) :: map
  def take!(map, keys \\ [])
  def take!(map, []), do: map
  def take!(map, keys) when is_list(keys) do
    keys
     |> Enum.filter(&Map.has_key?(map, &1))
     |> Item.tee(&(unless &1 == keys do
          raise MissingKeysError, expected: keys, actual: &1
        end))
    Map.take(map, keys)
  end

  @doc ~S"""
  Deletes the struct metadata from structs, but ordinary maps unchanged

  ## Examples

      PassiveSupport.Map.plain(%{foo: :bar})
      # => %{foo: :bar}

      defmodule Plane do
        defstruct plains: :great     # ... little plain punning for ya.
      end

      PassiveSupport.Map.plain(%Plane{})
      # => %{plains: :great}
  """
  @spec plain(struct | map) :: map
  def plain(struct) when is_struct(struct), do: Map.delete(struct, :__struct__)
  def plain(%{} = map), do: map
end
