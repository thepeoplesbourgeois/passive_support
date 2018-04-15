defmodule PassiveSupport.String do
  @spec parseable_integer?(String.t) :: boolean
  def parseable_integer?(string), do:
    Integer.parse(string) != :error

  @spec castable_integer?(String.t) :: boolean
  def castable_integer?(string) do
    case Integer.parse(string) do
    {_int, ""} ->
      true
    _ ->
      false
    end
  end

  @spec parseable_float?(String.t) :: boolean
  def parseable_float?(string), do:
    Float.parse(string) != :error

  @spec castable_float?(String.t) :: boolean
  def castable_float?(string) do
    case Float.parse(string) do
    {_flt, ""} ->
      true
    _ ->
      false
    end
  end

  @doc ~S"""
  Converts the provided pattern to a regular expression, if necessary,
  and then invokes `Regex.run` on the expression and the string.

  Useful for invoking regular expressions on strings in the middle of
  transformation pipelines.

  ## Examples

      iex> Ps.String.match("footwear, fun, and fondue", "((f[ou])[no]).+")
      ["footwear, fun, and fondue", "foo", "fo"]

      iex> Ps.String.match("fööd!", "öö")
      ["öö"]

      iex> Ps.String.match("footwear, fun, and fondue", ~r/((f[ou])[no]).+/U)
      ["foot", "foo", "fo"]
  """
  @spec match(String.t, Regex.t | String.t, [keyword]) :: [String.t]
  def match(string, pattern, opts \\ [])
  def match(string, %Regex{} = pattern, opts), do:
    Regex.run(pattern, string, opts)
  def match(string, "" <> pattern, opts), do:
    Regex.compile!(pattern, "u")
      |> Regex.run(string, opts)


  @doc ~S"""
  Converts the provided pattern to a regular expression, if necessary,
  and then invokes `Regex.scan` on the expression and the string.

  Useful for invoking regular expressions on strings in the middle of
  transformation pipelines.

  ## Examples

      iex> Ps.String.scan("footwear, fun, and fondue", "((f[ou])[no]).+")
      [["footwear, fun, and fondue", "foo", "fo"]]

      iex> Ps.String.scan("fööd!", "öö")
      [["öö"]]

      iex> Ps.String.scan("footwear, fun, and fondue", ~r/((f[ou])[no]).+/U)
      [["foot", "foo", "fo"], ["fun,", "fun", "fu"], ["fond", "fon", "fo"]]
  """
  @spec scan(String.t, Regex.t | String.t, keyword) :: [[String.t]]
  def scan(string, pattern, opts \\ [])
  def scan(string, %Regex{} = pattern, opts), do:
    Regex.scan(pattern, string, opts)
  def scan(string, "" <> pattern, opts), do:
    Regex.compile!(pattern, "u")
      |> Regex.scan(string, opts)


  defguardp valid_length(length) when is_integer(length) and length > 0
  @doc ~S"""
  Splits a string according to a given length or lengths.
  When a list of lengths is given, returns a list of lists
  of substrings of the given lengths. If the string
  does not fit within the given length(s), the final substring
  will be the remainder of the string.

  To retrieve only the result of the first split of the string,
  pass `first_split: true`. This is useful when your lengths
  sum up to the total length of the string being split.

  ## Examples

      iex> Ps.String.length_split("hello world!", 3)
      ["hel", "lo ", "wor", "ld!"]

      iex> Ps.String.length_split("hello world!", 5)
      ["hello", " worl", "d!"]

      iex> Ps.String.length_split("hello world!", 5, first_split: true)
      "hello"

      iex> Ps.String.length_split("I'm getting a little tired of hello world???", [10, 9, 7])
      [
        ["I'm gettin", "g a littl", "e tired"],
        [" of hello ", "world???"]
      ]

      iex> Ps.String.length_split("I'm getting a little tired of hello world...", [10, 9, 7], first_split: true)
      ["I'm gettin", "g a littl", "e tired"]
  """
  @spec length_split(String.t, integer | [integer], keyword) :: [String.t] | [[String.t]]
  def length_split(string, lengths, opts \\ [first_split: false])

  def length_split(string, length, first_split: true) when valid_length(length), do:
    hd(match(string, ~r".{1,#{length}}"))
  def length_split(string, length, first_split: false) when valid_length(length), do:
    scan(string, ~r".{1,#{length}}")
      |> Enum.map(fn [substring] -> substring end)
  def length_split(""<>string, [_|_]=lengths, first_split: true), do:
    lengths
      |> Enum.map_join(fn (length) when valid_length(length) -> "(.{1,#{length}})" end)
      |> Regex.compile!
      |> Regex.run(string)
      |> tl
  def length_split(""<>string, [_|_]=lengths, first_split: false), do:
    lengths
      |> Enum.map_join(fn (length) when valid_length(length) -> "(.{1,#{length}})" end)
      |> Regex.compile!
      |> Regex.scan(string)
      |> Enum.map(fn [_ | splits] -> splits end)

end
