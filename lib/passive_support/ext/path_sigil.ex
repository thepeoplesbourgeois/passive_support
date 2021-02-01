defmodule PassiveSupport.Path.Sigil do
  @moduledoc false

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
end
