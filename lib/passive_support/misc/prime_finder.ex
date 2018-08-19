defmodule PrimeFinder do
  @spec upto(integer()) :: map()
  def upto(1), do: %{"prime" => [{1, "1"}], "composite" => []}
  def upto(2) do
     %{ "prime" => [{2, "01", "0s": 1, "1s": 1}], "composite" => [] }
  end
  def upto(maximum) do
    map = 3..maximum
      |> Enum.reduce(
        upto(2),
        fn number, numbers ->
          bin_digits = number |> Integer.digits(2)
          bin_string = bin_digits |> Enum.reverse |> Enum.join
          zero_count = bin_digits |> Enum.count(fn num -> num == 0 end)
          one_count = bin_digits |> Enum.count(fn num -> num == 1 end)
          if Enum.any?(numbers["prime"], fn {prime, _bin_string, _stats} ->
            rem(number, prime) == 0
          end),
            do: %{ numbers |
              "composite" => [{number, bin_string, "0s": zero_count, "1s": one_count} | numbers["composite"]]
            },
            else: %{ numbers |
              "prime" => [{number, bin_string, "0s": zero_count, "1s": one_count} | numbers["prime"]]
            }
        end
      )

    %{ map |
        "prime" => [{1, "1"} | Enum.reverse(map["prime"])],
        "composite" => Enum.reverse(map["composite"])
      }
  end
end
