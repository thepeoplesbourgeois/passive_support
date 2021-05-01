defmodule PassiveSupport.Path.Sigil do
  @moduledoc false

  @doc """
  # The path sigil

  `~P` transforms its input into the argument to various functions
  within the `Path` module, for the quick and idiomatic usage of
  strings as filesystem paths. It accepts a variety of modifiers
  for accessing various kinds of paths. These modifiers are:

  - `'a'` for `Path.absname` (default)
  - `'b'` for `Path.basename`
  - `'d'` for `Path.dirname`
  - `'x'` for `Path.expand`
  - and `'w'` for `Path.wildcard`

  All of the functions are their single-argument arity variants, and
  therefore cannot have their behaviors specialized. Additionally, the sigil
  currently only allows for one modifier at a time, and will raise an
  `ArgumentError` if more than one is used at a time.

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

  # TODO: defmacro sigil_p
end
