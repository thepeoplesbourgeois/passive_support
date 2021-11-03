defmodule PassiveSupport.Path.Sigil do
  @moduledoc """
  ### The path sigil
  """

  @doc """
  Quickly and idiomatically build filesystem paths

  `import PassiveSupport.Path.Sigil` causes `~P` to invoke
  various functions within the `Path` module, for quick and idiomatic
  usage of filesystem paths. As its default behavior, `~P[path/to/something]`
  will expand to the output of `Path.absname("path/to/something")`, but other
  behaviors can be exposed depending on the modifier provided following the
  closing delimiter. The enabled modifiers are currently:

  - `'a'` for `Path.absname/1` (default)
  - `'b'` for `Path.basename/1`
  - `'d'` for `Path.dirname/1`
  - `'x'` for `Path.expand/1`
  - `'w'` for `Path.wildcard/1`
  - and `'wd'` for `Path.wildcard(path, match_dot: true)`

  Beyond that, there is no means of modifying function behavior any further,
  and interpolation through `~p` is not yet implemented. They both are on
  the roadmap for this module, but being that this maintainer fundamentally
  works on this library in his spare time, the ready date for those
  functionalities is decidedly TBD.

  ## Examples

      iex> ~P[foo]
      Path.absname("foo")

      iex> ~P[bar]a
      Path.absname("bar")

      iex> ~P[bat]b
      "bat"
      iex> ~P[bat/boy]b
      "boy"

      iex> ~P[fizz/buzz]d
      "fizz"
      iex> ~P[/etc/hosts]d
      "/etc"
      iex> ~P[/etc/config.d/nginx.conf]d
      "/etc/config.d"

      iex> ~P[./deps/phoenix/lib]x
      Path.expand("./deps/phoenix/lib")
      iex> ~P[~/.bash_profile]x
      Path.expand("~/.bash_profile")

      iex> ~P[**/*.txt]w
      Path.wildcard("**/*.txt")
  """
  defmacro sigil_P(path, modifiers)
  defmacro sigil_P(path, modifiers) when modifiers in [[], 'a'] do
    quote do: Path.absname(unquote(path))
  end

  defmacro sigil_P(path, 'b') do
    quote do: Path.basename(unquote(path))
  end

  defmacro sigil_P(path, 'd') do
    quote do: Path.dirname(unquote(path))
  end

  defmacro sigil_P(path, 'x') do
    quote do: Path.expand(unquote(path))
  end

  defmacro sigil_P(path, 'w') do
    quote do: Path.wildcard(unquote(path))
  end

  defmacro sigil_P(path, 'wd') do
    quote do: Path.wildcard(unquote(path), match_dot: true)
  end

  # TODO: defmacro sigil_p
end
