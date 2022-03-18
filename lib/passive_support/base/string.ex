defmodule PassiveSupport.String do
  @moduledoc """
  Helper functions for working with strings and UTF-8 binary data.
  """

  @doc ~S"""
  Converts the provided pattern to a regular expression, if necessary,
  and then invokes `Regex.run` on the expression and the string.

  Useful for invoking regular expressions on strings in the middle of
  transformation pipelines.

  ## Examples

      iex> match("footwear, fun, and fondue", "((f[ou])[no]).+")
      ["footwear, fun, and fondue", "foo", "fo"]

      iex> match("fööd!", "öö")
      ["öö"]

      iex> match("footwear, fun, and fondue", ~r/((f[ou])[no]).+/U)
      ["foot", "foo", "fo"]
  """
  @spec match(String.t(), Regex.t() | String.t(), keyword) :: [String.t()]
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

      iex> scan("footwear, fun, and fondue", "((f[ou])[no]).+")
      [["footwear, fun, and fondue", "foo", "fo"]]

      iex> scan("fööd!", "öö")
      [["öö"]]

      iex> scan("footwear, fun, and fondue", ~r/((f[ou])[no]).+/U)
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
  Splits a string by a given length or lengths.

  When one length is given, splits the string into a list of substrings
  of that length.

  When a list of lengths is given, returns a list of lists
  of substrings of the given lengths.

  If the string does not fit within the given length(s),
  the final substring will be the length of the remainder
  of the string.

  To retrieve only the first `length` or `lengths` of the string,
  pass `first_split: true`. Note that in the case of a single `length`,
  this is equivalent to calling `String.slice(string, 0..length)`, or
  `binary_part(string, 0, length)`. This is useful when, while supplying
  multiple lengths, only the first `lengths` of the given string are important
  to the program, or when the sum of `lengths` is equal to the length
  of the original string.

  ## Examples

      iex> length_split("hello world!", 3)
      ["hel", "lo ", "wor", "ld!"]

      iex> length_split("hello world!", 5)
      ["hello", " worl", "d!"]

      iex> length_split("hello world!", 5, first_split: true)
      "hello"

      iex> length_split("Life, the universe, and everything... is pattern-matchable", [10, 9, 7])
      [
        ["Life, the ", "universe,", " and ev"],
        ["erything..", ". is patt", "ern-mat"],
        ["chable"]
      ]

      iex> length_split("Life, the universe, and everything... is pattern-matchable", [10, 9, 7], first_split: true)
      ["Life, the ", "universe,", " and ev"]
  """
  @spec length_split(String.t(), integer | [integer], first_split: boolean) ::
          String.t() | list(String.t()) | list(list(String.t()))

  def length_split(string, lengths, opts \\ [first_split: false])

  def length_split(""<>string, length, first_split: true) when valid_length(length), do:
    String.slice(string, 0, length)
  def length_split(""<>string, length, first_split: false) when valid_length(length), do:
    string |> String.graphemes |> Stream.chunk_every(length) |> Enum.map(&Enum.join/1)
  def length_split("" <> string, [], _opts), do: string
  def length_split("" <> string, lengths, first_split: true) when is_list(lengths), do:
    do_length_split(String.graphemes(string), lengths)
  def length_split("" <> string, lengths, first_split: false) when is_list(lengths), do:
    do_length_split(String.graphemes(string), lengths, lengths)

  defp do_length_split([], _lengths), do: []
  defp do_length_split(_graphemes, []), do: []
  defp do_length_split(graphemes, [current_length | lengths]) do
    {substr, graphemes} = Enum.split(graphemes, current_length)
    [IO.iodata_to_binary(substr) | do_length_split(graphemes, lengths)]
  end

  defp do_length_split([], _lengths, _lengths_copy), do: []
  defp do_length_split(graphemes, lengths, _lengths_copy) do
    {substrings, rest} = Enum.reduce_while(lengths, {[], graphemes}, (fn
      (_length, {parts, []}) ->
        {:halt, {parts, []}}
      (length, {parts, graphemes}) ->
        {substr, rest} = Enum.split(graphemes, length)
        {:cont, {[IO.iodata_to_binary(substr) | parts], rest}}
    end))

    [Enum.reverse(substrings) | do_length_split(rest, lengths, lengths)]
  end

  @doc ~S"""
  Safely casts the string to an atom, returning `{:ok, atom}` if successful
  and `:error` if not.

  ## Examples

      iex> safe_existing_atom("ok")
      {:ok, :ok}
      iex> safe_existing_atom("not_particularly_ok")
      :error
  """
  @spec safe_existing_atom(String.t) :: {:ok, atom} | :error
  def safe_existing_atom("" <> string) do
    {:ok, String.to_existing_atom(string)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Returns a copy of `string` with a newline removed from the end.

  If there is no newline at the end of `string`, then it is returned unchanged

  ## Examples

      iex> chomp("hello world!\\n")
      "hello world!"

      iex> chomp("hello\\nworld!")
      "hello\\nworld!"

      iex> chomp("multiline!\\n\\n")
      "multiline!\\n"

      iex> chomp("single line!")
      "single line!"
  """
  @spec chomp(String.t) :: String.t
  def chomp(string), do: String.replace(string, ~r/\n$/, "", global: false)
end
