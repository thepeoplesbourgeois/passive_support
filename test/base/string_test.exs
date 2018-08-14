defmodule PassiveSupport.StringTest do
  alias PassiveSupport, as: Ps

  use ExUnit.Case, async: true
  doctest Ps.String

  describe "length_split" do
    test "preserves the structure of multipoint graphemes" do
      assert Ps.String.length_split("é", 1, first_split: true) == "é"
    end
  end

  describe "length_split when passed a list of lengths" do
    test "preserves the structure of multibyte graphemes " do
      assert Ps.String.length_split("æß", [2], first_split: true) == ["æß"]
    end
  end
end
