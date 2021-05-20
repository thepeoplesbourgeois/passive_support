defmodule PassiveSupport.Duration do
  alias __MODULE__
  @type t :: %Duration{}
  defstruct seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0

  @spec seconds(t, number) :: t
  def seconds(t \\ %Duration{}, time)
  def seconds(%Duration{seconds: s} = t, time), do: %{ t | seconds: s + time}

  @spec minutes(t, number) :: t
  def minutes(t \\ %Duration{}, time)
  def minutes(%Duration{minutes: m} = t, time), do: %{ t | minutes: m + time }

  @spec hours(t, number) :: t
  def hours(t \\ %Duration{}, time)
  def hours(%Duration{hours: h} = t, time), do: %{ t | hours: h + time }

  @spec days(t, number) :: t
  def days(t \\ %Duration{}, time)
  def days(%Duration{days: d} = t, time), do: %{ t | days: d + time }

  @spec weeks(t, number) :: t
  def weeks(t \\ %Duration{}, time)
  def weeks(%Duration{weeks: w} = t, time), do: %{ t | weeks: w + time }

  @spec months(t, number) :: t
  def months(t \\ %Duration{}, time)
  def months(%Duration{months: m} = t, time), do: %{ t | months: m + time }

  @spec years(t, number) :: t
  def years(t \\ %Duration{}, time)
  def years(%Duration{years: y} = t, time), do: %{ t | years: y + time }

  @doc """
  Returns the raw representation of seconds captured by the duration.

  ## Examples

      iex> minutes(10) |> hours(4) |> to_seconds
      15000

      iex> years(1) |> to_seconds
      525600 * 60
  """
  def to_seconds(%Duration{} = d) do
    d.seconds +
    in_seconds(d.minutes, :minutes) +
    in_seconds(d.hours, :hours) +
    in_seconds(d.days, :days) +
    in_seconds(d.weeks, :weeks) +
    in_seconds(d.months, :months) +
    in_seconds(d.years, :years)
  end

  defp in_seconds(time, :seconds), do: time
  defp in_seconds(time, :minutes), do: in_seconds(time * 60, :seconds)
  defp in_seconds(time, :hours), do: in_seconds(time * 60, :minutes)
  defp in_seconds(time, :days), do: in_seconds(time * 24, :hours)
  defp in_seconds(time, :weeks), do: in_seconds(time * 7, :days)
  # 365 days / 7 per week / 12 months = 4.3452381 weeks per average month
  defp in_seconds(time, :months), do: round(in_seconds(time * 4.3452381, :weeks))
  defp in_seconds(time, :years), do: in_seconds(time * 12, :months)

  @doc """
  Returns the raw number of milliseconds represented by the duration.

  ## Examples

      iex> minutes(10) |> hours(4) |> to_milliseconds
      15000000
  """
  @spec to_milliseconds(Duration.t) :: integer
  def to_milliseconds(%Duration{} = d) do
    (d.seconds +
    in_seconds(d.minutes, :minutes) +
    in_seconds(d.hours, :hours) +
    in_seconds(d.days, :days) +
    in_seconds(d.weeks, :weeks) +
    in_seconds(d.months, :months) +
    in_seconds(d.years, :years)) * 1000
  end

  defp millis(time), do: time * 1000
  defp millis(time, not_seconds), do: in_seconds(time, not_seconds) |> millis

  defimpl String.Chars do
    def to_string(duration) do
      map = Map.from_struct(duration)
      for unit <- ~W[year month week day hour minute second],
          amount = map[:"#{unit}s"],
          amount != 0 do
        case amount do
          1 ->
            [Kernel.to_string(1), " ", unit]
          plural ->
            [Kernel.to_string(plural), " ", unit, "s"]
        end
      end |> Enum.intersperse(", ") |> IO.chardata_to_string()
    end
  end
end
