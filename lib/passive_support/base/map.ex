defmodule PassiveSupport.Map do
  @moduledoc """
  Convenience functions for working with maps.
  """

  alias PassiveSupport, as: Ps

  @type key :: any

  @doc ~S"""
  Returns a new map with `key` replaced by `new_key` or the return of `fun`

  If `key` is not found within `map`, returns the `map` unaltered.

  Useful for when you're shuffling values around inside of a map,
  or, I dunno, going through your music collection and you discover
  you accidentally attributed an entire Beatles album to the Monkees.

  Although how you did that is beyond me. You monster.

  ## Examples

      iex> change_key(%{dog: "rusty"}, :dog, :cat)
      %{cat: "rusty"}

      iex> change_key(%{dog: "rusty"}, :dog, &(:"best_#{&1}"))
      %{best_dog: "rusty"}

      iex> change_key(%{1 => "foo", 2 => "bar", 5 => "idklol"}, 1, fn _key, map -> Enum.max(Map.keys(map)) + 1 end)
      %{2 => "bar", 5 => "idklol", 6 => "foo"}

      iex> change_key(%{cake_boss: "you blew it"}, :no_key_here, :oops)
      %{cake_boss: "you blew it"}
  """
  @spec change_key(map, key, key | (key -> key) | ((key, map) -> key)) :: map
  def change_key(map, key, fun) when is_map_key(map, key) and is_function(fun, 1) do
    {value, map} = Map.pop(map, key)
    put_in(map[fun.(key)], value)
  end
  def change_key(map, key, fun) when is_map_key(map, key) and is_function(fun, 2) do
    {value, map} = Map.pop(map, key)
    put_in(map[fun.(key, map)], value)
  end
  def change_key(map, key, new_key) when is_map_key(map, key) do
    {value, map} = Map.pop(map, key)
    put_in(map[new_key], value)
  end
  def change_key(map, _, _), do: map

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
      ** (PassiveSupport.ExistingAtomError) No atom exists for the values ["noo"]
  """
  def atomize_keys!(%{} = map) do
    {atoms, errors} = map
     |> Stream.map(fn {key, value} ->
          case key |> to_string |> Ps.String.safe_existing_atom do
            {:ok, atom} -> {atom, value}
            :error -> key
          end
        end)
     |> Enum.split_with(fn atom? -> is_tuple(atom?) end)
    case errors do
      [] -> atoms |> Enum.into(%{})
      _ -> raise(PassiveSupport.ExistingAtomError, expected: errors)
    end
  end

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
      ** (PassiveSupport.MissingKeysError) Expected to find keys ["c", "e"] but only found keys ["c"]
  """
  @spec take!(map, list) :: map
  def take!(map, keys \\ [])
  def take!(map, []), do: map
  def take!(map, keys) when is_list(keys) do
    keys
     |> Enum.filter(&Map.has_key?(map, &1))
     |> tap(&unless(&1 == keys,
          do: raise(PassiveSupport.MissingKeysError, expected: keys, actual: &1)
        ))
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
