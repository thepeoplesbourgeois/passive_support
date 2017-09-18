ExUnit.start

defmodule PassiveSupportTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport
  doctest PassiveSupport.Range, import: true
  doctest PassiveSupport.String, import: true
  doctest PassiveSupport.Integer, import: true
  doctest PassiveSupport.Enum, import: true
  doctest PassiveSupport.List, import: true
  doctest PassiveSupport.MapSet, import: true
end
