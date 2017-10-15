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

      iex> Ps.Range.includes?(5..1, 3)
      true
      iex> Ps.Range.includes?(5..1, 2..4)
      true
      iex> Ps.Range.includes?(5..1, 4..2)
      true
  """
  @spec includes?(Range.t, any) :: boolean
  def includes?(range, other_start..other_finish), do:
    includes?(range, other_start) and includes?(range, other_finish)
  def includes?(start..finish, point) when start <= finish, do:
    start <= point and point <= finish
  def includes?(start..finish, point), do:
    start >= point and point >= finish

  @doc ~S"""
  Returns `true` if either end of either range falls within the other.
  Returns `false` if the second argument is not a range.

  ## Examples

      iex> Ps.Range.overlaps?(1..5, 4..6)
      true
      iex> Ps.Range.overlaps?(4..6, 1..5)
      true
      iex> Ps.Range.overlaps?(1..5, 6..7)
      false

      iex> Ps.Range.overlaps?(1..5, 2..4)
      true
      iex> Ps.Range.overlaps?(2..4, 1..5)
      true

      iex> Ps.Range.overlaps?(5..1, 4..6)
      false
      iex> Ps.Range.overlaps?(4..6, 5..1)
      false
      iex> Ps.Range.overlaps?(1..5, 6..4)
      false
      iex> Ps.Range.overlaps?(6..4, 1..5)
      false
      iex> Ps.Range.overlaps?(6..4, 5..1)
      true
  """
  @spec overlaps?(Range.t, Range.t) :: boolean
  def overlaps?(start_1..finish_1, start_a..finish_a)
      when ((start_1 > finish_1) and (start_a < finish_a))
        or ((start_1 < finish_1) and (start_a > finish_a)),
      do:
        false
  def overlaps?(start_1..finish_1, start_a..finish_a), do:
    includes?(start_1..finish_1, start_a) or includes?(start_a..finish_a, start_1) or includes?(start_1..finish_1, finish_a)

  @doc ~S"""
  returns `true` if either range begins immediately after the other

  ## Examples

      iex> Ps.Range.adjacent?(1..5, 6..10)
      true
      iex> Ps.Range.adjacent?(6..10, 1..5)
      true
      iex> Ps.Range.adjacent?(10..6, 5..1)
      true
      iex> Ps.Range.adjacent?(5..1, 10..6)
      true

      iex> Ps.Range.adjacent?(0..4, 6..10)
      false
      iex> Ps.Range.adjacent?(6..10, 0..4)
      false
      iex> Ps.Range.adjacent?(10..6, 1..5)
      false
  """
  @spec adjacent?(Range.t, Range.t) :: boolean
  def adjacent?(start_1..finish_1, start_b..finish_b) when start_1 > finish_1, do:
    finish_1-1 == start_b or finish_b-1 == start_1
  def adjacent?(start_1..finish_1, start_b..finish_b), do:
    finish_1+1 == start_b or finish_b + 1 == start_1

  @doc ~S"""
  If the provided ranges overlap or are adjacent, returns a new range
  spanning the entirety of both

  ## Examples

      iex> Ps.Range.join(1..5, 6..10)
      1..10
      iex> Ps.Range.join(1..5, 4..8)
      1..8
      iex> Ps.Range.join(10..20, 5..15)
      5..20
      iex> Ps.Range.join(1..10, 2..8)
      1..10

      iex> Ps.Range.join(1..2, 5..10)
      ** (ArgumentError) Cannot join 1..2 and 5..10

      iex> Ps.Range.join(1..5, 10..5)
      ** (ArgumentError) Cannot join 1..5 and 10..5
  """
  @spec join(Range.t, Range.t) :: Range.t
  def join(range_1, range_a) do
    case overlaps?(range_1, range_a) or adjacent?(range_1, range_a) do
    true ->
      Enum.min([min(range_1), min(range_a)])..Enum.max([max(range_1), max(range_a)])
    false ->
      raise ArgumentError, "Cannot join #{inspect range_1} and #{inspect range_a}"
    end
  end


  @doc ~S"""
  Returns the size of the range

  ## Examples

      iex> Ps.Range.size(1..5)
      5
      iex> Ps.Range.size(0..5)
      6
      iex> Ps.Range.size(5..0)
      6
  """
  @spec size(Range.t) :: integer
  def size(start..start), do:
    1
  def size(start..finish) when finish < start, do:
    1+start-finish
  def size(start..finish), do:
    1+finish-start


  @doc ~S"""
  Returns the first number of the range

  ## Examples


      iex> Ps.Range.first(0..5)
      0
      iex> Ps.Range.first(5..0)
      5
  """
  @spec first(Range.t) :: integer
  def first(start.._finish), do:
    start

  @doc ~S"""
  Returns the last number of the range

  ## Examples

      iex> Ps.Range.last(0..5)
      5
      iex> Ps.Range.last(5..0)
      0
  """
  @spec last(Range.t) :: integer
  def last(_start..finish), do:
    finish

  @doc ~S"""
  Returns the larger end of the range

  ## Examples

      iex> Ps.Range.max(0..5)
      5
      iex> Ps.Range.max(5..0)
      5
  """
  def max(start..finish) when finish < start, do:
    start
  def max(_start..finish), do:
    finish

  @doc ~S"""
  Returns the smaller end of the range

  ## Examples

      iex> Ps.Range.min(0..5)
      0
      iex> Ps.Range.min(5..0)
      0
  """
  def min(start..finish) when finish < start, do:
    finish
  def min(start.._finish), do:
    start


  @doc ~S"""
  Returns a new range that immediately follows the range provided, with an equivalent size

  ## Examples

      iex> Ps.Range.next_page(1..10)
      11..20
      iex> Ps.Range.next_page(10..1)
      0..-9
  """
  @spec next_page(Range.t) :: Range.t
  def next_page(start..finish) when finish < start, do:
    finish-1..finish-(1+start-finish)
  def next_page(start..finish), do:
    finish+1..finish+(1+finish-start)


  @doc ~S"""
  Returns a new range that immediately precedes the range provided, with an equivalent size

  ## Examples

      iex> Ps.Range.prev_page(1..10)
      -9..0
      iex> Ps.Range.prev_page(10..1)
      20..11
  """
  @spec prev_page(Range.t) :: Range.t
  def prev_page(start..finish) when finish < start, do:
    (start+(1+start-finish))..finish+(1+start-finish)
  def prev_page(start..finish), do:
    (start-(1+finish-start))..start-1

end






