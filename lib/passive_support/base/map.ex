defmodule PassiveSupport.Map do

  @doc ~S"""
    Returns a version of `map` whose keys have all been
    converted to strings.

    ## Examples

        iex> Ps.Map.stringify_keys(%{7 => 8, "hey" => "ha", hi: "ho"})
        %{"7" => 8, "hey" => "ha", "hi" => "ho"}
    """
  def stringify_keys(%{} = map), do:
    map
      |> Stream.map(fn {key, value} -> {to_string(key), value} end)
      |> Enum.into(%{})

  @doc ~S"""
    Returns a version of `map` whose keys have all been
    converted to atoms, first by being coerced to a string,
    then being run through `String.to_existing_atom/1`

    ## Examples

        iex> [:oh, :yay] # existing keys
        iex> Ps.Map.atomize_keys!(%{"oh" => "ooh", 'yay' => 'yaaay'})
        %{oh: "ooh", yay: 'yaaay'}
        iex> Ps.Map.atomize_keys!(%{"oh" => "ooh", "noo" => "noooo"})
        ** (ArgumentError) argument error
    """
  def atomize_keys!(%{} = map), do:
    map
      |> Stream.map(fn {key, value} ->
           atom = key |> to_string |> String.to_existing_atom
           {atom, value}
         end)
      |> Enum.into(%{})

  @doc ~S"""
    Returns a version of `map` whose keys that can be
    coerced to existing atoms are converted thusly

    I'm not giving y'all the ridiculous footgun
    of wanton atom space pollution. I'm not some foot-shooting
    cowboy like `Jason`.

    ## Examples

        iex> [:oh, :yay] # existing keys
        iex> Ps.Map.safe_atomize_keys(%{"oh" => "ooh", 'yay' => 'yaaay'})
        %{oh: "ooh", yay: 'yaaay'}
        iex> Ps.Map.safe_atomize_keys(%{"oh" => "ooh", "noo" => "noooo"})
        %{oh: "ooh"}
    """
  def safe_atomize_keys(%{} = map),
    do: map
     |> Stream.map(fn {key, value} -> {to_string(key), value} end)
     |> Stream.filter(fn {key, _} -> PassiveSupport.Atom.exists?(key) end)
     |> Stream.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
     |> Enum.into(%{})

  @doc """
    Transforms a map-like entity into a map where any values that had
    been structs have been recursively converted to maps, down through
    to the terminal/leaf nodes of the entire entity tree.

    ## Examples

        iex> defmodule SomeStruct do
        ...>   defstruct foo: "", bar: ""
        ...> end
        iex> defmodule WrapperStruct do
        ...>   defstruct bitz: SomeStruct, botz: SomeStruct
        ...> end
        iex> Ps.Map.deep_from_struct(%{foo: "", bar: ""})
        %{foo: "", bar: ""}
        iex> Ps.Map.deep_from_struct(%{foo: struct(SomeStruct)})
        %{foo: %{foo: "", bar: ""}}
        iex> WrapperStruct |> struct |> Ps.Map.deep_from_struct()
        %{bitz: %{foo: "", bar: ""}, botz: %{foo: "", bar: ""}}
    """
  @spec deep_from_struct(struct | map) :: map
  def deep_from_struct(structish) when is_struct(structish) do
    structish
     |> Map.from_struct()
     |> deep_from_struct()
  end
  def deep_from_struct(map) when is_map(map) do
    map
     |> Enum.reduce(%{}, &deep_from_struct_/2)
  end

  defp deep_from_struct_({key, value}, acc) when is_struct(value) or is_map(value),
    do: put_in(acc[key], deep_from_struct(value))
  # defp deep_from_struct_({key, value}) when is_list(value),
  #   do: {key, Enum.map(value, &deep_from_struct/1)}
  defp deep_from_struct_({key, value}, acc), do: put_in(acc[key], value)

end
