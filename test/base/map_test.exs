defmodule PassiveSupport.MapTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport.Map, import: true
  import PassiveSupport.Map

  describe "plain/1" do
    defmodule OldStruct do
      defstruct some: :thing
    end

    test "removes struct metadata from maps" do
      assert plain(%OldStruct{}) == %{some: :thing}
      map = %{boo: :baa}
      assert plain(map) == map
    end
  end
end
