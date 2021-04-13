defmodule PassiveSupport.Math do
  @moduledoc """
  Mathematical functions.

  I'm not great at math.
  """

  @doc """
  Returns 1 if the number is positive, -1 if negative, and 0 if 0
  """
  @spec sign(number) :: -1 | 0 | 1
  def sign(0), do: 0
  def sign(number) when is_number(number), do:
    number / abs(number)

  defdelegate acos(x), to: :math
  defdelegate acosh(x), to: :math
  defdelegate asin(x), to: :math
  defdelegate asinh(x), to: :math
  defdelegate atan(x), to: :math
  defdelegate atan2(x, y), to: :math
  defdelegate atanh(x), to: :math
  defdelegate cos(x), to: :math
  defdelegate cosh(x), to: :math
  defdelegate erf(x), to: :math
  defdelegate erfc(x), to: :math
  defdelegate exp(x), to: :math
  defdelegate fmod(x, y), to: :math
  defdelegate log(x), to: :math
  defdelegate log10(x), to: :math
  defdelegate log2(x), to: :math
  defdelegate pi, to: :math
  defdelegate sin(x), to: :math
  defdelegate sinh(x), to: :math
  defdelegate sqrt(x), to: :math
  defdelegate tan(x), to: :math
  defdelegate tanh(x), to: :math

  defdelegate floor(x), to: Kernel
  defdelegate ceil(x), to: Kernel

  defdelegate fact(x), to: PassiveSupport.Integer, as: :factorial

  @doc """
  Raises `base` to the power of `exponent`.

  Since `:math.pow/2` always does floating point arithmetic, whereas
  `PassiveSupport.Integer.exponential/2` will do arbitrary precision arithmetic
  if the `exponent` is a positive integer, `Math.pow/2` checks the types of
  `base` and `exponent` and delegates out to the appropriate function based on
  what it finds.

  ## Examples

      iex> pow(2, 5)
      32

      iex> pow(2, 5.0)
      32.0

      iex> pow(2, 200)
      1606938044258990275541962092341162602522202993782792835301376

      iex> pow(2.0, 2000)
      ** (ArithmeticError)
  """
  @spec pow(number, number) :: number
  def pow(base, exponent) when is_integer(base) and is_integer(exponent),
    do: PassiveSupport.Integer.exponential(base, exponent)
  def pow(base, exponent), do: :math.pow(base, exponent)

end
