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
end
