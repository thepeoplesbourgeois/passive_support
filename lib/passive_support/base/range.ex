defmodule PassiveSupport.Range do
  @moduledoc """
  Helper functions for using ranges
  """

  @doc ~S"""
  Returns `true` if `element` is a number within the range and `false`
  if it is outside of the range or anything but a number. Also
  returns `true` for `Point` values of `element`

  ## Examples

      iex> Ps.Range.includes?(1..5, 3)
      true

      iex> Ps.Range.includes?(1..5, 5)
      true

      iex> Ps.Range.includes?(1..5, :math.pi)
      true

      iex> Ps.Range.includes?(1..5, :no)
      false

      iex> Ps.Range.includes?(1..5, nil)
      false

      iex> Ps.Range.includes?(1..5, 2..4)
      true
      iex> Ps.Range.includes?(1..5, 4..6)
      false
      iex> Ps.Range.includes?(1..5, 0..2)
      false
  """
  @spec includes?(Range.t, Range.t) :: boolean
  def includes?(range, other_start..other_finish), do:
    includes?(range, other_start) and includes?(range, other_finish)

  def includes?(start..finish, point), do:
    start <= point and point <= finish

  @doc ~S"""
  Returns `true` if either end of either range falls within the other.
  Returns `false` if the second argument is not a range.

  ## Examples

      iex> Ps.Range.overlaps?(1..5, 4..6)
      true

      iex> Ps.Range.overlaps?(1..5, -2..1)
      true

      iex> Ps.Range.overlaps?(4..6, 1..5)
      true

      iex> Ps.Range.overlaps?(4..6, 7..8)
      false

      iex> Ps.Range.overlaps?(1..5, 6)
      false
  """
  @spec overlaps?(Range.t, Range.t | number) :: boolean
  def overlaps?(range = _s.._f, other_start..other_finish), do:
    includes?(range, other_start) or includes?(range, other_finish)
  def overlaps?(_s.._f, _point), do:
    false

  @doc ~S"""
  Returns the size of the range

  ## Examples

      iex> Ps.Range.size(1..5)
      5

      iex> Ps.Range.size(0..5)
      6
  """
  @spec size(Range.t) :: integer
  def size(start..finish), do:
    1+finish-start


  @doc ~S"""
  Returns the last number of the range

  ## Examples

      iex> Ps.Range.max(0..5)
      5
  """
  @spec max(Range.t) :: integer
  def max(_start..finish), do:
    finish


  @doc ~S"""
  Returns the first number of the range

  ## Examples


      iex> Ps.Range.min(0..5)
      0
  """
  @spec min(Range.t) :: integer
  def min(start.._finish), do:
    start


  @doc ~S"""
  Returns a new range that immediately follows the range provided, with an equivalent size

  ## Examples

      iex> Ps.Range.next_page(1..10)
      11..20
  """
  @spec next_page(Range.t) :: Range.t
  def next_page(start..finish), do:
    finish+1..finish+1+(finish-start)


  @doc ~S"""
  Returns a new range that immediately precedes the range provided, with an equivalent size

  ## Examples

      iex> Ps.Range.prev_page(1..10)
      -9..0
  """
  @spec prev_page(Range.t) :: Range.t
  def prev_page(start..finish), do:
    (start-1-(finish-start))..start-1

end






