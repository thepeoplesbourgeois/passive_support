defmodule PinPipe do
  defmacro __using__(_) do
    mod = __MODULE__
    quote do
      import unquote(mod)
    end
  end

  defmacro left <|> right do
    IO.inspect(left)
    IO.inspect(right)
    IO.inspect(quote do
      left = unquote(left)
      right = unquote(right)
    end)
  end

  defmacro left |> right do
    [{h, _foo} | t] = Macro.unpipe({:|>, [], [left, right]})
    inspect [{h, _foo} | t]

    fun = fn {x, pos}, acc ->
      case x do
        {op, _, [_]} when op == :+ or op == :- ->
          message =
            <<"piping into a unary operator is deprecated, please use the ",
              "qualified name. For example, Kernel.+(5), instead of +5">>

          :elixir_errors.warn(__CALLER__.line, __CALLER__.file, message)

        _ ->
          :ok
      end

      Macro.pipe(acc, x, pos)
    end

    :lists.foldl(fun, h, t)
  end

end

#   iex> import PinPipe
#   iex> 1..2 <|> Enum.reverse
#   [2, 1]

#   iex> "Hello, world!" <|> Regex.replace(~r/world/, _v_, "José")
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

#   3 <|> Enum.slice([1,2,3,4,5], _v_.._v_)
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
