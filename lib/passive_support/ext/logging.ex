defmodule PassiveSupport.Logging do
  @moduledoc """
  Helper functions for logging and inspecting.

  These functions serve two primary purposes and one subtle but kinda nice purpose:

  1. To keep outputs colorized even when they're sent to Logger,
  2. To keep `IO.inspect` and `Kernel.inspect` from truncating away data
     you might need if you intend, e.g., to save a function's return
     as fixture data for debugging purposes
  i. Not needing to temporarily `require Logger` when you're debugging some module
     yet *aren't* using IEx to do so, because you're computer science's version of
     a Luddite, I guess
  """

  import Kernel, except: [inspect: 1, inspect: 2]

  @doc """
  Sensible defaults for `IO.inspect` and `Kernel.inspect` when you want to see a value in its entirety
  """
  @spec inspect_opts :: [printable_limit: :infinity, limit: :infinity, width: 170, pretty: true]
  def inspect_opts do
    [
      printable_limit: :infinity,
      limit: :infinity,
      width: 170,
      pretty: true
    ]
  end

  @doc """
  Pretty good, pretty pretty, color choices for inspected data
  """
  @spec coloration_opts ::
    {:syntax_colors, [number: :yellow, string: :green, list: :light_magenta,
      map: :light_cyan, atom: :light_blue, tuple: :"[:black_background, :white]",
      regex: :"[:cyan_background, :light_yellow]"
    ]}
  def coloration_opts do
    {:syntax_colors, [number: :yellow, string: :green, list: :light_magenta,
      map: :light_cyan, atom: :light_blue, tuple: [:black_background, :white],
      regex: [:cyan_background, :light_yellow]
    ]}
  end

  @doc """
  Sensible option defaults for logging information to stdout
  """
  @spec logger_opts :: [
    syntax_colors: [number: :yellow, string: :green, list: :light_magenta,
        map: :light_cyan, atom: :light_blue, tuple: :"[:black_background, :white]",
        regex: :"[:cyan_background, :light_yellow]"
      ],
    printable_limit: :infinity, limit: :infinity, width: 170, pretty: true
  ]
  def logger_opts do
    [coloration_opts() | inspect_opts()]
  end

  @doc """
  calls `Kernel.inspect/2` on `item` with `logger_opts/0`.

  If you wish to overwrite some portion of the `opts` send to `inspect`,
  consider calling `Kernel.inspect` and passing `Utils.logger_opts() ++
  overwrites` as your `opts` instead of calling this function.
  """
  def inspect(item, to_log \\ false) do
    Kernel.inspect(item, if(to_log, do: logger_opts(), else: inspect_opts()))
  end

  require Logger

  for level <- [:alert, :critical, :debug, :emergency, :error, :info, :notice, :warn] do
    @doc """
    Logs a `message` with sensible formatting at the `:#{level}` level, logging a `label` first, if provided.
    """
    def unquote(level)(message \\ nil, label \\ nil) do
      if label, do: apply(Logger, unquote(level), [[label, ":"]])
      if message, do: apply(Logger, unquote(level), [__MODULE__.inspect(message, true)])
      message
    end
  end
end
