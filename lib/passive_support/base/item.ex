defmodule PassiveSupport.Item do
  @doc ~S"""
  Returns `true` of any value that would return `true` with `Enum.empty?/1`,
  as well as to bare tuples, binaries with no data, and strings containing
  only whitespace, `nil`, and `false`. Returns `false` for any other value.

  Note that while a string containing only whitespace can be considered blank,
  a charlist of the same nature will return `false`. Because charlists are
  represented internally as lists of integers, a charlist of whitespace would
  be indescernible from a list of numeric integers, neither of which would be
  individually considered blank, and therefore should not be regarded as blank
  in tandem.

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
      iex> Ps.Item.blank?('  ') # [32, 32]
      false
      iex> Ps.Item.blank?(" hi ")
      false
  """
  @spec blank?(any) :: boolean
  def blank?(item), do:
    PassiveSupport.Blank.blank?(item)

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
  @spec present?(any) :: boolean
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
  @spec presence(t) :: t
  def presence(item), do:
    if present?(item), do: item, else: nil

end


defprotocol PassiveSupport.Blank do
  @fallback_to_any true
  @spec blank?(any) :: boolean
  def blank?(item)
end

defimpl PassiveSupport.Blank, for: BitString do
  def blank?(<<>>), do:
    true
  def blank?(""<>string), do:
    String.match?(string, ~r/\A[[:space:]]*\z/u)
end

defimpl PassiveSupport.Blank, for: Map do
  def blank?(map), do:
    map == %{}
end

defimpl PassiveSupport.Blank, for: Tuple do
  def blank?(tuple), do:
    tuple == {}
end

defimpl PassiveSupport.Blank, for: List do
  def blank?(list), do:
    list == []
end

defimpl PassiveSupport.Blank, for: Any do
  def blank?(item), do:
    if Enumerable.impl_for(item), do: Enum.empty?(item), else: !item
end