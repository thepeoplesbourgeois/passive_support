defmodule PassiveSupport.String do
  def parseable_integer?(string), do: Integer.parse(string) != :error


  def castable_integer?(string), do: Integer.parse(string) != :error


  def parseable_float?(string), do: Float.parse(string) != :error


  def castable_float?(string), do: Float.parse(string) != :error


  @doc """
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
  def match(string, pattern, opts \\ [])
  def match(string, "" <> pattern, opts) do
    with {:ok, expression} <- Regex.compile(pattern, "u"),
      do: Regex.run(expression, string, opts)
  end
  def match(string, %Regex{} = pattern, opts) do
    pattern |> Regex.run(string, opts)
  end


  @doc """
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
  def scan(string, pattern, opts \\ [])
  def scan(string, "" <> pattern, opts) do
    with {:ok, expression} <- Regex.compile(pattern, "u"),
      do: Regex.scan(expression, string, opts)
  end
  def scan(string, %Regex{} = pattern, opts), do: pattern |> Regex.scan(string, opts)
end