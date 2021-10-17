defmodule PassiveSupport.PostBody do
  @moduledoc """
  Functions for working with `www-form-urlencoded` data
  """

  @doc ~s"""
  Deep-parses the map into a string formatted according to the `www-form-urlencoded` spec.

  ## Examples

      iex> form_encoded(%{
      ...>   "success_url" => "https://localhost:4001/foo/bert?id={ID}",
      ...>   "cancel_url" => "https://localhost:4001/foo/bar",
      ...>   "blips" => ["blop", "blorp", "blep"],
      ...>   "array" => [
      ...>     %{"something" => "five dollars", "quantity" => 1},
      ...>     %{"line" => "line", "item" => "item"},
      ...>     %{"let's" => ~W[really flerf this up]}
      ...>   ],
      ...>   "mode" => "median",
      ...>   "just_to_make_sure" => %{
      ...>     "we got" => "all", "the edge" => "cases", "we can think of" => "covered"
      ...>   }
      ...> })
      ~S(array[0][quantity]=1&#{
        }array[0][something]=five+dollars&#{
        }array[1][item]=item&#{
        }array[1][line]=line&#{
        }array[2][let%27s][0]=really&#{
        }array[2][let%27s][1]=flerf&#{
        }array[2][let%27s][2]=this&#{
        }array[2][let%27s][3]=up&#{
        }blips[0]=blop&#{
        }blips[1]=blorp&#{
        }blips[2]=blep&#{
        }cancel_url="https://localhost:4001/foo/bar"&#{
        }just_to_make_sure[the+edge]=cases&#{
        }just_to_make_sure[we+can+think+of]=covered&#{
        }just_to_make_sure[we+got]=all&#{
        }mode=median&#{
        }success_url="https://localhost:4001/foo/bert?id={ID}"#{
      })

      iex> form_encoded(%{something: :dotcom})
      "something=dotcom"
  """
  @spec form_encoded(map) :: String.t
  # Need to differentiate keyword lists, keywordish lists, and maps from generic lists;
  # the former can all be form encoded, generic lists cannot be.
  def form_encoded([{_,_}|_] = enum), do: do_form_encoding(enum)
  def form_encoded(enum) when is_map(enum), do: do_form_encoding(enum)
  defp do_form_encoding(enum, data_path \\ [])
  defp do_form_encoding([{_,_}|_] = enum, data_path) do
    enum
     |> Enum.map(fn
          {key, value} ->
            if Enumerable.impl_for(value),
              do: do_form_encoding(value, [key | data_path]),
              else: [construct_path([key | data_path]), sanitize_input(value)] |> Enum.join("=")
        end)
     |> Enum.join("&")
  end
  defp do_form_encoding(%{} = enum, data_path) do
    enum
     |> Enum.map(fn
          {key, value} ->
            if Enumerable.impl_for(value),
              do: do_form_encoding(value, [key | data_path]),
              else: [construct_path([key | data_path]), sanitize_input(value)] |> Enum.join("=")
        end)
     |> Enum.join("&")
  end
  defp do_form_encoding([_|_] = enum, data_path) do
    enum
     |> Stream.with_index
     |> Enum.map(fn
          {value, index} ->
            if Enumerable.impl_for(value),
              do: do_form_encoding(value, [index | data_path]),
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
