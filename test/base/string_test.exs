ExUnit.start

defmodule PassiveSupport.StringTest do
  alias PassiveSupport, as: Ps

  use ExUnit.Case, async: true
  doctest Ps.String

  describe "length_split" do
    test "preserves the structure of multibyte graphemes" do
      assert Ps.String.length_split("é", 1, first_split: true) == "é"
    end
  end
end
