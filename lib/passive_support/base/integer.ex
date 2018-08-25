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

  @doc """
  Qualifies if `integer` is even.
  """
  defguard is_even(integer)
    when is_integer(integer)
    and rem(integer, 2) == 0

  @doc """
  Qualifies if `integer` is odd.
  """
  defguard is_odd(integer)
    when is_integer(integer)
    and rem(integer, 2) == 1

  @doc ~S"""
  Arbitrary-precision factorial.

  ## Examples

      iex> Ps.Integer.factorial(5)
      120

      iex> Ps.Integer.factorial(6)
      720

      iex> Ps.Integer.factorial(-6)
      -720
  """
  @spec factorial(integer) :: integer
  def factorial(0), do: 1
  def factorial(integer)
  when is_negative(integer),
    do: -factorial(abs(integer))
  def factorial(integer)
  when is_integer(integer), do: do_fact(integer-1, integer)

  defp do_fact(1, factored), do: factored
  defp do_fact(next, factored), do: do_fact(next-1, factored * next)

  @doc ~S"""
  Arbitrary-precision exponentiation

  Original implementation from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190

  ## Examples

      iex> Ps.Integer.exponential(2, 5)
      32

      iex> Ps.Integer.exponential(2, 10)
      1024

      iex> Ps.Integer.exponential(2, 100)
      1267650600228229401496703205376

      iex> Ps.Integer.exponential(2, -2)
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

  # def tail_exp(base, factor), do: do_tail_exp(factor, [1], base)

  # defp do_tail_exp(0, factors, _base), do: factors |> List.flatten |> Enum.reduce(&Kernel.*/2)
  # defp do_tail_exp(next_factor, [previous | _] = factors, base) when rem(next_factor, 2) == 1 do
  #   do_tail_exp(next_factor-1, [next_factor * previous | factors], base)
  # end
  # defp do_tail_exp(next_factor, factors, _base) do
  #   factors
  #     |> List.flatten
  #     |> Enum.reduce(&Kernel.*/2)

  # end


  # from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-44065965
  # TODO: but not an iterative tail-call. this is O(n) where the above is closer to O(ln n)
  #  def  exp(n, k), do: exp(n, k, 1)
  #  defp exp(_, 0, acc), do: acc
  #  defp exp(n, k, acc), do: exp(n, k - 1, n * acc)

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
