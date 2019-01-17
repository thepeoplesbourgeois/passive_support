defmodule PassiveSupport.Math do
  @moduledoc """
  Mathematical functions.
  """

  @doc """
  Returns 1 if the number is positive, -1 if negative, and 0 if 0
  """
  def sign(0), do: 0
  def sign(number) when is_number(number), do:
    number / abs(number)
end
