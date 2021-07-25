defmodule PassiveSupport.PostBody do
  @doc ~s"""
  Deep-parses the map into a string formatted according to the `www-form-urlencoded` spec.

  ## Examples

      iex> parse_form_data(%{
      ...>   "success_url" => "https://localhost:4001/membership/subscribe?session_id={CHECKOUT_SESSION_ID}",
      ...>   "cancel_url" => "https://localhost:4001/membership/nevermind",
      ...>   "payment_types" => ["grass", "gas", "ass"],
      ...>   "line_items" => [%{"price" => "five dollars", "quantity" => 1}, %{"line" => "line", "item" => "item"}],
      ...>   "mode" => "subscription",
      ...>   "just_to_make_sure" => %{
      ...>     "we got" => "all", "the edge" => "cases", "we can think of" => "covered"
      ...>   }
      ...> })
      ~S(cancel_url="https://localhost:4001/membership/nevermind"&#{
        }just_to_make_sure[the+edge]=cases&#{
        }just_to_make_sure[we+can+think+of]=covered&#{
        }just_to_make_sure[we+got]=all&#{
        }line_items[0][price]=five+dollars&#{
        }line_items[0][quantity]=1&#{
        }line_items[1][item]=item&#{
        }line_items[1][line]=line&#{
        }mode=subscription&#{
        }payment_types[0]=grass&#{
        }payment_types[1]=gas&#{
        }payment_types[2]=ass&#{
        }success_url="https://localhost:4001/membership/subscribe?session_id={CHECKOUT_SESSION_ID}"#{
      })

      iex> parse_form_data(%{something: :dotcom})
      "something=dotcom"
  """
  @spec parse_form_data(map) :: String.t
  def parse_form_data([{_,_}|_] = enum), do: do_parse_form_data(enum)
  def parse_form_data(enum) when is_map(enum), do: do_parse_form_data(enum)
  defp do_parse_form_data(enum, data_path \\ [])
  defp do_parse_form_data([{_,_}|_] = enum, data_path) do
    enum
     |> Enum.map(fn
          {key, value} ->
            if Enumerable.impl_for(value),
              do: do_parse_form_data(value, [key | data_path]),
              else: [construct_path([key | data_path]), sanitize_input(value)] |> Enum.join("=")
        end)
     |> Enum.join("&")
  end
  defp do_parse_form_data(%{} = enum, data_path) do
    enum
     |> Enum.map(fn
          {key, value} ->
            if Enumerable.impl_for(value),
              do: do_parse_form_data(value, [key | data_path]),
              else: [construct_path([key | data_path]), sanitize_input(value)] |> Enum.join("=")
        end)
     |> Enum.join("&")
  end
  defp do_parse_form_data([_|_] = enum, data_path) do
    enum
     |> Stream.with_index
     |> Enum.map(fn
          {value, index} ->
            if Enumerable.impl_for(value),
              do: do_parse_form_data(value, [index | data_path]),
              else: [construct_path([index | data_path]), sanitize_input(value)] |> Enum.join("=")
        end)
     |> Enum.join("&")
  end

  defp construct_path(path, path_iolist \\ [])
  defp construct_path([key | []], path_iolist),
    do: IO.chardata_to_string([sanitize_input(key) | path_iolist])
  defp construct_path([key_or_index | path], path_iolist),
    do: construct_path(path, [["[" , sanitize_input(key_or_index), "]"], path_iolist])

  defp sanitize_input(index) when is_integer(index) or is_atom(index), do: to_string(index)
  defp sanitize_input("" <> input) do
    case String.match?(input, ~r"[/&?]") do
      true -> input |> URI.parse |> to_string |> inspect
      false -> URI.encode_www_form(input)
    end
  end
end
