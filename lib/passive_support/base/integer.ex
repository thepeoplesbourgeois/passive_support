defmodule PassiveSupport.Integer do

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
  def exp(base, factor) when rem(factor, 2) == 1, do:
    base * exp(base, factor - 1)
  def exp(base, factor) do
    result = exp(base, div(factor, 2))
    result * result
  end

  # from https://stackoverflow.com/questions/32024156/how-do-i-raise-a-number-to-a-power-in-elixir#answer-44065965
  # TODO: but not an iterative tail-call. this is O(n) where the above is closer to O(ln n)
  #  def  exp(n, k), do: exp(n, k, 1)
  #  defp exp(_, 0, acc), do: acc
  #  defp exp(n, k, acc), do: exp(n, k - 1, n * acc)

end