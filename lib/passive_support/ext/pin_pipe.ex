defmodule PinPipe do
  @moduledoc """
  PinPipe operator.

  Similar to `left |> right`, `left ~> right` applies the `left` expression
  as an argument in the `right` expression. By itself, it behaves synonymously
  to `left |> right`.

      iex> 1..3 ~> Enum.to_list
      [1, 2, 3]

  However, PinPipe is also capable of applying `left` within `right` at any
  point in `right` where the pipe-pin, `_v_`, appears.

      iex> 1..4 ~> String.slice("Hello, world!", _v_)
      "ello"

  `_v_` can also appear in multiple places within `right`.

      iex> 3 ~> _v_ * _v_
      9
      iex> 3 ~> _v_ * _v_ * _v_
      27

  To avoid making potentially expensive recomputations of `left`, when `~>`
  detects multiple usages of `_v_` within `right`, it wraps `right` in a
  function closure, and applies the evaluated value of `left` at the points
  where `_v_` appears.
  """
  defmacro __using__(_) do
    mod = __MODULE__
    quote do
      import unquote(mod)
    end
  end

  # defmacrop recursive_detect(quoted, atom) do

  # end

  @doc """
  Pipes `left` in to `right` either as the first argument, at the spot
  where `_v_` appears, or as the value of the variable `v_`, replacing
  `_v_` a `right`
      iex> "hi" ~> String.duplicate(3)
      "hihihi"
      # "hi" |> String.duplicate(3)

      iex> 3 ~> String.duplicate("hi", _v_)
      "hihihi"
      # String.duplicate("hi", 3)

      iex> Task.await(Task.async(fn -> Process.sleep(50); "hi" end)) ~> _v_ <> _v_ <> _v_
      "hihihi"
      # (fn v_ -> v_ <> v_ <> v_ end).(Task.await(Task.async(fn -> Process.sleep(50); "hi" end)))

      iex> "hi" ~> _v_ <> _v_ <> _v_ |> String.split("h") |> String.join("o")
      "hohoho"
      # (fn v_ -> v_ <> v_ <> v_ end).("hi") |> String.split("i") |> String.join("o")

      # it's acceptable if the right-hand of `~>` needs to be `(_v_ <> _v_ <> _v_)`
      # to achieve this, but it's how PinPipe should work
  """
  defmacro left ~> right do
    IO.inspect(left)
    IO.inspect(right)
    IO.inspect(quote do
      left = unquote(left)
      right = unquote(right)
    end)
  end
end
#   iex> "Hello, world!" ~> Regex.replace(~r/world/, _v_, "José")
#   {:.., [line: 15], [1, 2]}
#   {{:., [line: 15], [{:__aliases__, [line: 15], [:Enum]}, :reverse]}, [line: 15],
#    [{:_v_, [line: 15], nil}]}
#   {:__block__, [],
#    [
#      {:=, [], [{:left, [], PinPipe}, {:.., [line: 15], [1, 2]}]},
#      {:=, [],
#       [
#         {:right, [], PinPipe},
#         {{:., [line: 15], [{:__aliases__, [line: 15], [:Enum]}, :reverse]},
#          [line: 15], [{:_v_, [line: 15], nil}]}
#       ]}
#    ]}

#   3 ~> Enum.slice([1,2,3,4,5], _v_.._v_)
#   3
#   {{:., [line: 15], [{:__aliases__, [line: 15], [:Enum]}, :slice]}, [line: 15],
#    [
#      [1, 2, 3, 4, 5],
#      {:.., [line: 15], [{:_v_, [line: 15], nil}, {:_v_, [line: 15], nil}]}
#    ]}

#   {:__block__, [],
#    [
#      {:=, [], [{:left, [], PinPipe}, 3]},
#      {:=, [],
#       [
#         {:right, [], PinPipe},
#         {{:., [line: 15], [{:__aliases__, [line: 15], [:Enum]}, :slice]},
#          [line: 15],
#          [
#            [1, 2, 3, 4, 5],
#            {:.., [line: 15], [{:_v_, [line: 15], nil}, {:_v_, [line: 15], nil}]}
#          ]}
#       ]}
#    ]}
