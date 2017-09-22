defmodule PassiveSupport.Item do
  @doc ~S"""
  Returns `true` of any value that would return `true` with `Enum.empty?/1`,
  as well as to bare tuples, binaries with no data, and strings containing
  only whitespace, `nil`, and `false`. Returns `false` for any other value.

  ## Examples

      iex> Ps.Item.blank?({})
      true
      iex> Ps.Item.blank?(%{})
      true
      iex> Ps.Item.blank?(%MapSet{})
      true
      iex> Ps.Item.blank?(0)
      false
      iex> Ps.Item.blank?(nil)
      true
      iex> Ps.Item.blank?(false)
      true
      iex> Ps.Item.blank?("  ")
      true
      iex> Ps.Item.blank?(" hi ")
      false
  """
  def blank?([]), do:
    true
  def blank?({}), do:
    true
  def blank?(%{}), do:
    true
  def blank?(<<>>), do:
    true
  def blank?(""<>string), do:
    String.match?(string, ~r/\A[[:space:]]*\z/u)
  def blank?(item) do
    cond do
    Enumerable.impl_for(item) ->
      Enum.empty?(item)
    true ->
      !item
    end
  end

  @doc ~S"""
  Returns `true` of any value that is not `blank?/1`

  ## Examples

      iex> Ps.Item.present?({})
      false
      iex> Ps.Item.present?(%{})
      false
      iex> Ps.Item.present?(%MapSet{})
      false
      iex> Ps.Item.present?(0)
      true
      iex> Ps.Item.present?(nil)
      false
      iex> Ps.Item.present?(false)
      false
      iex> Ps.Item.present?("  ")
      false
      iex> Ps.Item.present?(" hi ")
      true
  """
  def present?(item), do:
    !blank?(item)

  @doc ~S"""
  Returns `nil` for any `blank?/1` value, and returns the value back otherwise.

  ## Examples

      iex> Ps.Item.presence({})
      nil
      iex> Ps.Item.presence(%{})
      nil
      iex> Ps.Item.presence(nil)
      nil
      iex> Ps.Item.presence(false)
      nil
      iex> Ps.Item.presence([false])
      [false]
      iex> Ps.Item.presence("  ")
      nil
      iex> Ps.Item.presence(" hi ")
      " hi "
  """
  def presence(item) do
    case blank?(item) do
    true ->
      nil
    false ->
      item
    end
  end

end