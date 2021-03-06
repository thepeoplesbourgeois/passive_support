defmodule PassiveSupport.Integer do
  import Integer, only: [is_odd: 1]

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
  def factorial(integer) when integer in 0..1, do: 1
  def factorial(integer) when is_negative(integer),
    do: -factorial(abs(integer))
  def factorial(integer) when is_integer(integer),
    do: do_fact(integer-1, integer)

  defp do_fact(1, factored), do: factored
  defp do_fact(next, factored), do: do_fact(next-1, factored * next)

  @doc ~S"""
  Arbitrary-precision exponentiation

  Original implementation from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190

  ## Examples

      iex> exponential(2, 5)
      32

      iex> exponential(2, 10)
      1024

      iex> exponential(2, 100)
      1267650600228229401496703205376

      iex> exponential(2, -2)
      0.25
  """
  # TODO: tail-call optimize
  @spec exponential(integer, integer) :: integer

  def exponential(_, 0), do:
    1
  def exponential(base, factor) when is_negative(factor), do: 1 / (exponential(base, -factor))
  def exponential(base, factor) when is_odd(factor) do
    recursed_factor = exponential(base, factor - 1)
    base * recursed_factor
  end
  def exponential(base, factor) do
    recursed_factor = exponential(base, div(factor, 2))
    recursed_factor * recursed_factor
  end

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
  def formatted(integer, opts \\ []) do
    separator = Keyword.get(opts, :separator, ",")
    spacing = Keyword.get(opts, :spacing, 3)
    integer
      |> Integer.digits
      |> Stream.map(&to_string/1)
      |> Enum.reverse
      |> Stream.chunk_every(spacing)
      |> Enum.join(separator)
      |> String.reverse
  end

end
