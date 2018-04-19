defmodule PassiveSupport.String do
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
  @spec match(String.t(), Regex.t() | String.t(), [keyword]) :: [String.t()]
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
  @spec scan(String.t(), Regex.t() | String.t(), keyword) :: [[String.t()]]
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
  pass `first_split: true`. This is useful when the lengths of
  your substrings sum up to the length of the original string,
  and you want to access those substrings directly.

  ## Examples

      iex> Ps.String.length_split("hello world!", 3)
      ["hel", "lo ", "wor", "ld!"]

      iex> Ps.String.length_split("hello world!", 5)
      ["hello", " worl", "d!"]

      iex> Ps.String.length_split("hello world!", 5, first_split: true)
      "hello"

      iex> Ps.String.length_split("Life, the universe, and everything... is pattern-matchable", [10, 9, 7])
      [
        ["Life, the ", "universe,", " and ev"],
        ["erything..", ". is patt", "ern-mat"],
        ["chable"]
      ]

      iex> Ps.String.length_split("Life, the universe, and everything... is pattern-matchable", [10, 9, 7], first_split: true)
      ["Life, the ", "universe,", " and ev"]
  """
  @spec length_split(String.t(), integer | [integer], first_split: boolean) ::
          String.t() | list(String.t()) | list(list(String.t()))

  def length_split(string, lengths, opts \\ [first_split: false])

  def length_split(""<>string, length, first_split: true) when valid_length(length), do:
    String.slice(string, 0, length)
  def length_split(""<>string, length, first_split: false) when valid_length(length), do:
    string |> String.graphemes |> Stream.chunk_every(length) |> Enum.map(&Enum.join(&1))
  def length_split("" <> string, [], _opts), do: string
  def length_split("" <> string, lengths, first_split: true) when is_list(lengths), do:
    do_length_split(String.graphemes(string), lengths)
  def length_split("" <> string, lengths, first_split: false) when is_list(lengths), do:
    do_length_split(String.graphemes(string), lengths, lengths)

  defp do_length_split([], _lengths), do: []
  defp do_length_split(_graphemes, []), do: []
  defp do_length_split(graphemes, [current_length | lengths]) do
    {substr, graphemes} = Enum.split(graphemes, current_length)
    [Enum.join(substr) | do_length_split(graphemes, lengths)]
  end

  defp do_length_split([], _lengths, _lengths_copy), do: []
  defp do_length_split(graphemes, lengths, _lengths_copy) do
    {substrings, rest} = lengths
      |> Enum.reduce_while({[], graphemes},
           (fn
            (_length, {parts, []}) ->
              {:halt, {parts, []}}
            (length, {parts, graph}) ->
              {substr, rest} = Enum.split(graph, length)
              {:cont, {[Enum.join(substr) | parts], rest}}
            end)
         )
    [ Enum.reverse(substrings) | do_length_split(rest, lengths, lengths) ]
  end
end
