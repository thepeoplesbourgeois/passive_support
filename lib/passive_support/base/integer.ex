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

  # Derived from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190
  @doc ~S"""
  Arbitrary-precision exponentiation

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

  import Bitwise

  defp derivation(base, exponent) do
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
    #  |> PassiveSupport.Stream.with_memo({base, 1}, fn
    #       1, {product, primer} -> product * primer
    #       :odd, {product, primer} -> {product * product, product * primer}
    #       :even, {product, primer} -> {product * product, primer}
    #     end)
    #  |> Enum.reduce(fn
    #       {1, product}, _nope -> product
    #       _doesnt_matter, _still_nope -> nil
    #     end)
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
