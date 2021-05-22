defmodule PassiveSupport.ExistingAtomError do
  defexception [:message]

  def exception(args) do
    message = IO.chardata_to_string [
      "No atom exists for the values ",
      inspect(args[:expected])
    ]
    %__MODULE__{message: message}
  end
end
