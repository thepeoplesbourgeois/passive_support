defmodule Benchmark do
  @time 15
  @warmup 3
  alias PassiveSupport.Integer, as: Int

  def maths, do: Benchee.run(%{
    "tail-call recursive" => fn {base, exp} -> Int.exponential(base, exp) end,
    # "recursive" => fn {base, exp} -> Int.pow(base, exp) end
  },
  inputs:
    for [base, xs] <- [[2, 15..19], [3, 9..12], [5, 4..8], [7, 2..6], [11, 2..5]],
      xpnt <- xs do
      {base, xpnt}
    end
     |> Stream.with_index(1)
     |> Stream.map(fn {{base, exp}, index} ->
          {"#{index}: #{base}^(#{base}^#{exp})", {base, Int.exponential(base, exp)}}
        end)
     |> Enum.to_list,
  time: @time,
  warmup: @warmup
  )
end
