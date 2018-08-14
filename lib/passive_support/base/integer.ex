defmodule PassiveSupport.Integer do
  @doc ~S"""
  Returns the factorial of `n`

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
  when is_integer(integer)
  and integer < 0,
    do: -factorial(abs(integer))
  def factorial(integer)
  when is_integer(integer), do: do_fact([integer])

  defp do_fact([0 | factors]), do: Enum.reduce(factors, &Kernel.*/2)
  defp do_fact([next | _factors] = factors),
    do: do_fact([next-1 | factors])

  @doc ~S"""
  Returns an arbitrary-precision integer representation of `base^factor`,
  which must be integers. This contrasts to the behavior of `:math.pow/2`,
  which accepts floats, and consistently returns a float.

  Original implementation from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-32030190

  ## Examples

      iex> Ps.Integer.exp(2, 5)
      32

      iex> Ps.Integer.exp(2, 10)
      1024

      iex> Ps.Integer.exp(2, 100)
      1267650600228229401496703205376
  """
  # TODO: tail-call optimize
  @spec exp(integer, integer) :: integer

  def exp(_, 0), do:
    1
  def exp(base, factor) when rem(factor, 2) == 1 do
    recursed_multiplier = exp(base, factor - 1)
    result = base * recursed_multiplier
    result
  end
  def exp(base, factor) do
    recursed_multiplier = exp(base, div(factor, 2))
    result = recursed_multiplier * recursed_multiplier
    result
  end

  def tail_exp(base, factor), do: do_tail_exp(factor, [1], base)

  defp do_tail_exp(0, factors, _base), do: factors |> List.flatten |> Enum.reduce(&Kernel.*/2)
  defp do_tail_exp(next_factor, [previous | _] = factors, base) when rem(next_factor, 2) == 1 do
    do_tail_exp(next_factor-1, [next_factor * previous | factors], base)
  end
  defp do_tail_exp(next_factor, factors, _base) do
    factors
      |> List.flatten
      |> Enum.reduce(&Kernel.*/2)

  end


  # from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-44065965
  # TODO: but not an iterative tail-call. this is O(n) where the above is closer to O(ln n)
  #  def  exp(n, k), do: exp(n, k, 1)
  #  defp exp(_, 0, acc), do: acc
  #  defp exp(n, k, acc), do: exp(n, k - 1, n * acc)

end
