defmodule PassiveSupport.MapTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport.Map, import: true
  import PassiveSupport.Map

  describe "plain/1" do
    defmodule SomeStruct do
      defstruct some: :thing
    end

    test "removes struct metadata from maps" do
      assert plain(%SomeStruct{}) == %{some: :thing}
      assert plain(%{some: :thing}) == %{some: :thing}
    end
  end
end
