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

      iex> Ps.String.length_split("hello world!", 8)
      ["hello wo", "rld!"]

      iex> Ps.String.length_split("hello world!", 5, first_split: true)
      "hello"

      iex> Ps.String.length_split("I'm getting a little tired of hello world...", [10, 9, 7])
      [
        ["I'm gettin", "g a littl", "e tired"],
        [" of hello ", "world..."]
      ]

      iex> Ps.String.length_split("I'm getting a little tired of hello world...", [10, 9, 7], first_split: true)
      ["I'm gettin", "g a littl", "e tired"]
  """
  @spec length_split(String.t(), integer | [integer], first_split: boolean) ::
          [String.t()] | [[String.t()]]
  def length_split(string, lengths, opts \\ [first_split: false])

  def length_split(string, length, opts) when valid_length(length) do
    result = length_split(string, [length], opts)
    if opts[:first_split], do: hd(result), else: Enum.map(result, &hd/1)
  end

  def length_split("" <> string, [], _opts), do: string
  def length_split("" <> string, [length | remaining_lengths], first_split: true), do:
    length_split(String.graphemes(string), remaining_lengths, "", length, [])
  def length_split("" <> string, [length | remaining_lengths] = all_lengths, first_split: false), do:
    length_split(String.graphemes(string), remaining_lengths, [], length, [], all_lengths, [])

  defp length_split(
         orig,
         remaining_lengths,
         current_substring,
         current_length,
         substrings
       )
  defp length_split([], _lengths, new, _length, parts), do:
    Enum.reverse([new | parts])
  defp length_split(_orig, [], new, 0, parts), do:
    length_split([], [], new, 0, parts)
  defp length_split(orig, [next | rest], "", 0, parts), do:
    length_split(orig, rest, "", next, parts)
  defp length_split(orig, [next | rest], new, 0, parts), do:
    length_split(orig, rest, "", next, [new | parts])
  defp length_split([next | rest], lengths, new, length, parts) when valid_length(length), do:
    length_split(rest, lengths, IO.iodata_to_binary([new, next]), length - 1, parts)

  defp length_split(
         orig,
         remaining_lengths,
         current_substring,
         current_length,
         working_substrings,
         lengths_copy,
         all_substrings
       )

  defp length_split([], _lengths, new, _length, parts, _original_lengths, all_substrings), do:
    Enum.reverse([Enum.reverse([new | parts]) | all_substrings])
    # [new|parts]
    #   |> Enum.reverse
    #   |> (fn substrings -> [substrings | all_substrings] end).()
    #   |> Enum.reverse
  defp length_split(orig, [], new, 0, parts, [next | rest] = og_lengths, all_substrings), do:
    length_split(
      orig,
      rest,
      "",
      next,
      [],
      og_lengths,
      [Enum.reverse([new | parts]) | all_substrings]
    )
  defp length_split(orig, [next | rest], "", 0, parts, og_lengths, all_substrings), do:
    length_split(orig, rest, "", next, parts, og_lengths, all_substrings)
  defp length_split(orig, [next | rest], new, 0, parts, og_lengths, all_substrings), do:
    length_split(orig, rest, "", next, [new | parts], og_lengths, all_substrings)
  defp length_split([next | rest], lengths, new, length, parts, og_lengths, all_substrings)
       when valid_length(length),
       do:
         length_split(
           rest,
           lengths,
           IO.iodata_to_binary([new, next]),
           length - 1,
           parts,
           og_lengths,
           all_substrings
         )
end
