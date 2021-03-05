defmodule PassiveSupport.ItemTest do
  use ExUnit.Case, async: true
  doctest PassiveSupport.Item, import: true
  import PassiveSupport.Item

  describe "dig" do
    defmodule SomeStruct do
      defstruct [:some]
    end

    defmodule SuperStruct do
      defstruct nested: %SomeStruct{
        some: [
          0, 1, %SomeStruct{
            some: %{"oh hi" => "how are ya", :i_am => [well: :fine]}
          }
        ]
      }
    end

    test "handles a dig through lists, keyword lists, tuples, structs, and maps" do
      struct = %SuperStruct{}
      assert dig(struct, [:nested, :some, 2, :some, "oh hi"]) == "how are ya"
      assert dig(struct, [:nested, :some, 2, :some, :i_am, :well]) == :fine
    end

    test "works with defaults" do
      assert dig(%{}, :a) == nil
      assert dig(%{}, :a, "default, dear Brutus, lies not in our stars...") == "default, dear Brutus, lies not in our stars..."
    end
  end
end
