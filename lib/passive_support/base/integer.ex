defmodule PassiveSupport.Integer do
  @doc """
  Qualifies if `integer` is an integer less than 0.
  """
  defguard is_negative(integer)
    when is_integer(integer)
    and integer < 0

  @doc """
  Qualifies if `integer` is a natural number or 0. Exists
  to differentiate 0 from being either positive or negative
  """
  defguard is_nonnegative(integer)
    when is_integer(integer)
    and integer >= 0

  @doc """
  Qualifies if `integer` is an integer greater than 0.
  """
  defguard is_positive(integer)
    when is_integer(integer)
    and integer > 0

  @doc ~S"""
  Arbitrary-precision factorial.

  ## Examples

      iex> Ps.Integer.factorial(5)
      120

      iex> Ps.Integer.factorial(6)
      720

      iex> Ps.Integer.factorial(-6)
      (ArithmeticError) Cannot get the factorial of a negative number.
  """
  @spec factorial(integer) :: integer
  def factorial(0), do: 1
  def factorial(integer)
  when is_negative(integer),
    do: raise ArithmeticError, message: "Cannot get the factorial of a negative number."
  def factorial(integer)
  when is_integer(integer), do: do_fact(integer-1, integer)

  defp do_fact(1, factored), do: factored
  defp do_fact(next, factored), do: do_fact(next-1, factored * next)

  @doc ~S"""
  Arbitrary-precision exponentiation. Useful for cases where the result of `:math.pow/2` 
  would be too large to represent as a floating point number.

  ## Examples

      iex> Ps.Integer.exponential(2, 5)
      32

      iex> Ps.Integer.exponential(2, 10)
      1024

      iex> Ps.Integer.exponential(2, 100)
      1267650600228229401496703205376

      iex> Ps.Integer.exponential(2, -2)
      0.25

      iex> Ps.Integer.exponential(0, 0)
      1
  """
  @spec exponential(integer, integer) :: integer

  def exponential(_, 0), do: 1
  def exponential(base, factor) when is_negative(factor), do: 1 / (exponential(base, -factor))
  def exponential(base, factor) when Integer.is_odd(factor) do
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

      iex> PassiveSupport.Integer.human_readable(57468291379)
      "57,468,291,379"
      iex> PassiveSupport.Integer.human_readable(57468291379, separator: "_")
      "57_468_291_379"
      iex> PassiveSupport.Integer.human_readable(57468291379, spacing: 4)
      "574,6829,1379"
  """
  def human_readable(integer, opts \\ []) do
    separator = Keyword.get(opts, :separator, ",")
    spacing = Keyword.get(opts, :spacing, 3)
    integer
      |> Integer.digits
      |> Stream.map(&to_string/1)
      |> Enum.reverse
      |> Enum.chunk_every(spacing)
      |> Enum.join(separator)
      |> String.reverse
  end

end
