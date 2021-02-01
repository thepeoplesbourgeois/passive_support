defmodule PassiveSupport.StringTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport.String, import: true

  describe "length_split" do
    test "preserves the structure of multibyte graphemes" do
      assert PassiveSupport.String.length_split("é", 1, first_split: true) == "é"
    end
  end

  describe "length_split when passed a list of lengths" do
    test "preserves the structure of multibyte graphemes " do
      assert PassiveSupport.String.length_split("æß", [2], first_split: true) == ["æß"]
    end
  end
end
