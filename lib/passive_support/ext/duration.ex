defmodule PassiveSupport.Duration do
  import PassiveSupport.Integer, only: [divrem: 2]
  alias __MODULE__
  @type t :: %Duration{}
  defstruct seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0

  @doc """
  Combines the values of two durations into one duration.

  ## Examples

      iex> 5 |> days |> add(12 |> minutes)
      %Duration{days: 5, minutes: 12}

      iex> d = days(10) |> months(10) |> years(2)
      %Duration{years: 2, months: 10, days: 10}
      iex> years(3) |> months(-10) |> days(-21) |> seconds(42) |> add(d)
      %Duration{years: 5, days: -11, seconds: 42}
  """
  @spec add(t, t) :: t
  def add(%Duration{} = d1, %Duration{} = d2) do
    d1map = d1 |> Map.from_struct()
    d2map = d2 |> Map.from_struct()

    Stream.map(d1map, fn {key, value} ->
      {key, value + d2map[key]}
    end)
     |> then(&struct!(Duration, &1))
  end

  for singular <- ~w[second minute hour day week month year]a,
      plural = :"#{singular}s" do
    @doc """
    Adds `time` to the `Duration`'s `#{plural}`.

    ## Examples

        iex> #{plural}(5)
        %Duration{#{plural}: 5}
    """
    @spec unquote(plural)(t, number) :: t
    def unquote(plural)(t \\ %Duration{}, time)
    def unquote(plural)(%Duration{unquote(plural) => p} = t, time),
      do: %{ t | unquote(plural) => p + time}

    @doc """
    Convenience alias for #{plural}

       iex> Duration.#{singular}
       %Duration{#{plural}: 1}

       iex> Duration.#{singular}(5)
       %Duration{#{plural}: 5}
    """
    @spec unquote(singular)(t, number) :: t
    def unquote(singular)(t \\ %Duration{}, time \\ 1)
    # catch the case where one argument is passed. Elixir can't tell which position it's supposed to fill.
    def unquote(singular)(t, _time) when is_integer(t), do: unquote(plural)(t)
    def unquote(singular)(%Duration{} = t, time),
      do: unquote(plural)(t, time)
  end
  @doc """
  Returns the raw representation of seconds captured by the duration.

  ## Examples

      iex> minutes(10) |> hours(4) |> to_seconds
      15000

      iex> years(1) |> to_seconds
      31556952
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
  defp in_seconds(time, :months), do: in_seconds(time * 2629746, :seconds)
  defp in_seconds(time, :years), do: in_seconds(time * 12, :months)

  @doc """
  Returns the raw number of milliseconds represented by the duration.

  ## Examples

      iex> minutes(10) |> hours(4) |> to_milliseconds
      15000000
  """
  @spec to_milliseconds(Duration.t) :: integer
  def to_milliseconds(%Duration{} = duration) do
    to_seconds(duration) * 1000
  end

  @doc """
  Returns a `DateTime` that is `duration` earlier than `date`

  ## Examples

      iex> minutes(10) |> hours(4) |> ago(~U[2020-02-02 12:00:00Z])
      ~U[2020-02-02 07:50:00Z]

      iex> 1 |> month |> until(~U[2020-02-02 12:00:00Z])
      ~U[2020-01-02 12:00:00Z]

      iex> 1 |> month |> before(~U[2021-03-31 12:00:00Z])
      ~U[2020-02-28 12:00:00Z]
  """

  @spec ago(Duration.t, DateTime.t) :: DateTime.t
  def ago(%Duration{} = duration, now \\ DateTime.utc_now()) do
    %{
      year: now_year, month: now_month, day: now_day,
      hour: now_hour, minute: now_minute, second: now_second
    } = now
    %{
      years: years, months: months, days: days,
      hours: hours, minutes: minutes, seconds: seconds
    } = duration

    {minute_rollover, then_seconds} = divrem(now_second - seconds, 60)
    {hour_rollover, then_minutes} = divrem(now_minute - (minutes + minute_rollover), 60)
    {day_rollover, then_hours} = divrem(now_hour - (hours + hour_rollover), 24)
    day_rollover_abacus = {now_year, now_month, Calendar.ISO.days_in_month(now_year, now_month)}
    {then_subyear, then_submonth, then_days} = Stream.unfold({days + day_rollover, day_rollover_abacus}, fn
      {remaining_days, {then_subyear, then_submonth, days_in_then_submonth}
      } when remaining_days <= days_in_then_submonth ->
        nil
      # {remaining_days, then_subyear, then_submonth, days_in_then_submonth}
    end)

    _ = [then_seconds, then_minutes, then_hours, then_days, then_submonth, then_subyear, now_year, now_month, years, months]
    now
  end

  for synonym <- ~w[before earlier until]a do
    @doc "An alias for `ago/2`"
    @spec unquote(synonym)(Duration.t, DateTime.t) :: DateTime.t
    def unquote(synonym)(duration, now \\ DateTime.utc_now), do: ago(duration, now)
  end

  for future_tense <- [:following, :since, :from_now] do
    @spec unquote(future_tense)(Duration.t, DateTime.t) :: DateTime.t
    def unquote(future_tense)(%Duration{} = duration, now \\ DateTime.utc_now()) do
      {added_years, remainder_months} = case duration.months do
        0 -> {0, 0}
        nonzero -> divrem(nonzero, 12)
      end
      duration = %{ duration | years: duration.years + added_years, months: remainder_months}

      now = %{ now | month: rem(now.month - remainder_months, 12) + 1}
      (DateTime.to_unix(now) + to_seconds(duration))
       |> DateTime.from_unix!()
    end
  end

  defimpl String.Chars, for: __MODULE__ do
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

  defimpl Inspect, for: __MODULE__ do
    import Inspect.Algebra
    def inspect(duration, opts) do
      logger_opts = PassiveSupport.Logging.logger_opts
      map = Map.from_struct(duration)
      one = Kernel.inspect(1, logger_opts)
      for unit <- ~W[year month week day hour minute second],
          amount = map[:"#{unit}s"],
          amount != 0 do
        case amount do
          1 ->
            [one, " ", unit]
          plural ->
            [Kernel.inspect(plural, logger_opts), " ", "#{unit}s"]
        end |> IO.iodata_to_binary
      end
       |> then(fn it -> container_doc("", it, "", opts, fn i, _opts -> i end, separator: ",") end)
    end
  end
end
