ExUnit.start

defmodule PassiveSupportTest do
  alias PassiveSupport, as: Ps

  use ExUnit.Case, async: true
  doctest Ps
  doctest Ps.Range
  doctest Ps.String
  doctest Ps.Integer
  doctest Ps.Enum
  doctest Ps.List
  doctest Ps.MapSet
end
