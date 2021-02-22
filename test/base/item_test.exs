defmodule PassiveSupport.ItemTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport.Item, import: true
  import PassiveSupport.Item

  describe "dig" do
    defmodule SomeStruct do
      defstruct some: nil, thing: nil
    end

    defmodule SuperStruct do
      defstruct nested: %SomeStruct{
        some: [
          0, 1, %SomeStruct{
            some: %{"oh hi" => "how are ya"}
          }
        ],
        thing: :thing
      }
    end

    test "handles a dig through structs" do
      struct = %SuperStruct{}
      assert dig(struct, [:nested, :some, 2, :some, "oh hi"]) == "how are ya"
    end
  end
end
