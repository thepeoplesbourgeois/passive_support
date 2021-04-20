defmodule Benchmark do
  @time 8
  @warmup 2
  alias PassiveSupport.Integer, as: Int

  def maths, do: Benchee.run(%{
    "A. body-recursive" => fn {base, exp} -> Int.pow(base, exp) end,
    "B. iterative" => fn {base, exp} -> Int.iter_exponential(base, exp) end,
    "C. tail-recursive" => fn {base, exp} -> Int.tail_exponential(base, exp) end
  },
  inputs:
    for [base, xs] <- [[2, 17..19], [3, 10..12], [5, 6..8], [7, 3..6], [11, 3..5]],
      xpnt <- xs do
      {base, xpnt}
    end
     |> Stream.with_index(1)
     |> Stream.map(fn {{base, exp}, index} ->
          {"#{index}: #{base}^(#{base}^#{exp})", {base, Int.iter_exponential(base, exp)}}
        end)
     |> Enum.to_list,
  time: @time,
  warmup: @warmup,
  save: %{path: "exponanza_" <> (DateTime.utc_now |> DateTime.to_iso8601(:basic) |> String.split(".") |> hd) <> ".benchee"}
  )
end
