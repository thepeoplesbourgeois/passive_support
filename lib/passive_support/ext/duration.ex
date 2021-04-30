defmodule PassiveSupport.Duration do
  alias __MODULE__, as: D
  @type t :: %D{}
  defstruct seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0

  @doc """
  Returns the raw number of milliseconds represented by the duration.


  """
  @spec to_milliseconds(D.t) :: integer
  def to_milliseconds(%D{} = d) do
    millis(d.seconds, :seconds) +
    millis(d.minutes, :minutes) +
    millis(d.hours, :hours) +
    millis(d.days, :days) +
    millis(d.weeks, :weeks) +
    millis(d.months, :months) +
    millis(d.years, :years)
  end

  defp millis(time, :seconds), do: time * 1000
  defp millis(time, :minutes), do: millis(time * 60, :seconds)
  defp millis(time, :hours), do: millis(time * 60, :minutes)
  defp millis(time, :days), do: millis(time * 24, :hours)
  defp millis(time, :weeks), do: millis(time * 7, :days)
  # 365 days / 7 per week / 12 months = 4.3452381 weeks per average month
  defp millis(time, :months), do: round(millis(time * 4.3452381, :weeks))
  defp millis(time, :years), do: millis(time * 12, :months)

  @spec seconds(t, number) :: t
  def seconds(t \\ %D{}, time)
  def seconds(%D{seconds: s} = t, time), do: %{ t | seconds: s + time}

  @spec minutes(t, number) :: t
  def minutes(t \\ %D{}, time)
  def minutes(%D{minutes: m} = t, time), do: %{ t | minutes: m + time }

  @spec hours(t, number) :: t
  def hours(t \\ %D{}, time)
  def hours(%D{hours: h} = t, time), do: %{ t | hours: h + time }

  @spec days(t, number) :: t
  def days(t \\ %D{}, time)
  def days(%D{days: d} = t, time), do: %{ t | days: d + time }

  @spec weeks(t, number) :: t
  def weeks(t \\ %D{}, time)
  def weeks(%D{weeks: w} = t, time), do: %{ t | weeks: w + time }

  @spec months(t, number) :: t
  def months(t \\ %D{}, time)
  def months(%D{months: m} = t, time), do: %{ t | months: m + time }

  @spec years(t, number) :: t
  def years(t \\ %D{}, time)
  def years(%D{years: y} = t, time), do: %{ t | years: y + time }
end
