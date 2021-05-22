defmodule PassiveSupport.Integer do
  import Integer, only: [is_odd: 1, is_even: 1]
  @doc """
  Qualifies if `integer` is an integer less than 0.
  """
  defguard is_negative(integer)
    when is_integer(integer)
    and integer < 0

  @doc """
  Qualifies if `integer` is a natural number or 0.
  """
  defguard is_nonnegative(integer)
    when is_integer(integer)
    and integer >= 0

  @doc """
  Qualifies if `integer` is an integer greater than 0.

  (adhering to the mathematical principle that 0 is neither positive nor negative)
  """
  defguard is_positive(integer)
    when is_integer(integer)
    and integer > 0

  @doc """
  Returns the quotient and the remainder of `dividend ÷ divisor`

  ## Examples

      iex> remdiv(3, 2)
      {1, 1}

      iex> remdiv(-325, 60)
      {-5, -25}

      iex> remdiv(11, 3)
      {3, 2}
  """
  @spec remdiv(integer, integer) :: {integer, integer}
  def remdiv(dividend, divisor) when is_integer(dividend) and is_integer(divisor),
    do: {div(dividend, divisor), rem(dividend, divisor)}

  @doc ~S"""
  Arbitrary-precision factorial.

  ## Examples

      iex> factorial(5)
      120

      iex> factorial(6)
      720

      iex> factorial(-6)
      -720

      iex> factorial(1)
      1
  """
  @spec factorial(integer) :: integer
  def factorial(0), do: 1
  def factorial(integer) when is_negative(integer),
    do: -factorial(-integer)
  def factorial(integer) when is_integer(integer),
    do: 1..integer |> Enum.reduce(fn int, product -> product * int end)

  import Bitwise
  # Derived from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190
  @doc ~S"""
  Arbitrary-precision exponentiation.

  Will be deprecated by Elixir [v1.12.0](https://github.com/elixir-lang/elixir/commit/b11a119f52c882e2ab0f35040ef4a4b4e9d23065)

  ## Examples

      iex> exponential(2, 10)
      1024

      iex> exponential(3, 3)
      27

      iex> exponential(2, 100)
      1267650600228229401496703205376

      iex> exponential(5, -3)
      0.008

      iex> exponential(9832, 0)
      1

      iex> exponential(0, 2)
      0

      iex> exponential(0, 0)
      1
  """
  @spec exponential(integer, integer) :: number
  def exponential(_base, 0), do: 1
  def exponential(0, _exponent), do: 0
  def exponential(base, 1), do: base
  def exponential(base, exponent) when is_negative(exponent), do: 1 / exponential(base, -exponent)
  def exponential(base, exponent) do
    derivation(base, exponent)
  end

  defp derivation(product, primer \\ 1, power)
  defp derivation(product, primer, 1), do: product * primer
  defp derivation(product, primer, power) when is_odd(power),
    do: derivation(product * product, primer * product, (power >>> 1))
  defp derivation(product, primer, power) when is_even(power),
    do: derivation(product * product, primer, (power >>> 1))

  @doc """
  Converts an integer to a string, with a `separator` (default `","`)
  inserted, starting in from the right side of the number, spaced apart
  by the number of digits specified by `spacing` (default `3`).

  ## Examples

      iex> formatted(57468291379)
      "57,468,291,379"
      iex> formatted(57468291379, separator: "_")
      "57_468_291_379"
      iex> formatted(57468291379, spacing: 4)
      "574,6829,1379"
  """
  @spec formatted(integer, separator: String.t, spacing: integer) :: String.t
  def formatted(integer, opts \\ []) do
    separator = opts[:separator] || ","
    spacing = opts[:spacing] || 3
    integer
      |> Integer.digits
      |> Stream.map(&to_string/1)
      |> Enum.reverse
      |> Stream.chunk_every(spacing)
      |> Enum.join(separator)
      |> String.reverse
  end

end
