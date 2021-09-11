defmodule PassiveSupport.Utils do
  for level <- [:alert, :critical, :debug, :emergency, :error, :info, :notice, :warn] do
    defdelegate unquote(level)(message, label \\ nil), to: PassiveSupport.Logging
  end

  @doc """
  Zippy check of what the `config_env` was at compile time
  """
  @env Application.get_env(:mix, :env)
  def env(), do: @env

  @doc """
  Starts a Pry session at the line of code where invoked, in a nonblocking
  manner with respect to the calling process, but only when the
  """
  defmacro prytask do
    if env() == :dev, do: (quote do
      Task.start fn ->
        require IEx
        IEx.pry
      end
    end)
  end
end
