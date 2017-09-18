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

  @doc """
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
  def match(string, "" <> pattern, opts), do:
    with {:ok, expression} <- Regex.compile(pattern, "u"),
      do: Regex.run(expression, string, opts)
  def match(string, %Regex{} = pattern, opts), do:
    Regex.run(pattern, string, opts)



  @doc """
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
  @spec scan(String.t, Regex.t | String.t, [keyword]) :: [[String.t]]
  def scan(string, pattern, opts \\ [])
  def scan(string, "" <> pattern, opts), do:
    with {:ok, expression} <- Regex.compile(pattern, "u"),
      do: Regex.scan(expression, string, opts)
  def scan(string, %Regex{} = pattern, opts), do:
    Regex.scan(pattern, string, opts)
end