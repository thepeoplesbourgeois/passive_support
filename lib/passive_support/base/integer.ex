defmodule PassiveSupport.Integer do
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
  def factorial(0), do: 1
  def factorial(integer) when is_negative(integer),
    do: -factorial(-integer)
  def factorial(integer) when is_integer(integer),
    do: 1..integer |> Enum.reduce(fn int, product -> product * int end)

  import Bitwise
  # Derived from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190
  @doc ~S"""
  Arbitrary-precision exponentiation

  ## Examples

      iex> tail_exponential(2, 10)
      1024

      iex> tail_exponential(3, 3)
      27

      iex> tail_exponential(2, 100)
      1267650600228229401496703205376

      iex> tail_exponential(5, -3)
      0.008

      iex> tail_exponential(9832, 0)
      1

      iex> tail_exponential(0, 2)
      0

      iex> tail_exponential(0, 0)
      1
  """
  @spec tail_exponential(integer, integer) :: number
  def tail_exponential(_base, 0), do: 1
  def tail_exponential(0, _exponent), do: 0
  def tail_exponential(base, 1), do: base
  def tail_exponential(base, exponent) when is_negative(exponent), do: 1 / tail_exponential(base, -exponent)
  def tail_exponential(base, exponent) do
    tail_derivation(base, exponent)
  end

  defp tail_derivation(product, primer \\ 1, power)
  defp tail_derivation(product, primer, 1), do: product * primer
  defp tail_derivation(product, primer, power) when (power &&& 1) == 1,
    do: tail_derivation(product * product, primer * product, (power >>> 1))
  defp tail_derivation(product, primer, power),
    do: tail_derivation(product * product, primer, (power >>> 1))

  def iter_exponential(base, 1), do: base
  def iter_exponential(base, exponent) when is_negative(exponent), do: 1 / iter_exponential(base, -exponent)
  def iter_exponential(base, exponent) do
    iter_derivation(base, exponent)
  end

  defp iter_derivation(base, exponent) do
    {base, 1, exponent}
     |> Stream.unfold(fn
          nil -> nil
          {product, primer, 1} -> {product*primer, nil}
          {product, primer, exp} when (exp &&& 1) == 1 ->
            {nil, {product*product, primer*product, (exp >>> 1)}}
          {product, primer, exp} ->
            {nil, {product * product, primer, (exp >>> 1)}}
        end)
     |> Enum.find(&(&1))
  end

  def pow(base, exponent) when is_negative(exponent), do: 1 / pow(base, -exponent)
  def pow(base, exponent) when is_integer(base) and is_integer(exponent) do
    if is_negative(exponent), do: :erlang.error(:badarith, [base, exponent])
    guarded_pow(base, exponent)
  end

  # https://en.wikipedia.org/wiki/Exponentiation_by_squaring
  defp guarded_pow(_, 0), do: 1
  defp guarded_pow(b, 1), do: b
  defp guarded_pow(b, e) when (e &&& 1) == 0, do: guarded_pow(b * b, e >>> 1)
  defp guarded_pow(b, e), do: guarded_pow(b * b, e >>> 1) * b

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
