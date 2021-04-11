defmodule MissingKeysError do
  defexception [:message]

  def exception(args) do
    message = IO.chardata_to_string [
      "Expected to find keys ",
      inspect(args[:expected]),
      " but only found keys ",
      inspect(args[:actual])
    ]
    %MissingKeysError{message: message}
  end
end
