# PassiveSupport

**Helpful functions for handling data in Elixir, inspired by the Ruby library ActiveSupport**

<a href="https://ko-fi.com/thepeoplesbourgeois36330">![Support me on Ko-Fi](https://fumbling-shortterm-millipede.gigalixirapp.com/images/panhandling_dot_app.png?vsn=d)</a>
## Installation

Add passive_support to your list of dependencies in `mix.exs`:

```elixir
  defp deps do
    [
      {:passive_support, "~> 0.8.3"}
    ]
  end
```

Install by running `mix deps.get` in your terminal.

## Usage

Because passive_suppport uses the same module namespaces as modules provided by Elixir's standard
library, aliasing the top-level namespace to the acronym `Ps` is the recommended way to access
the provided functions

```elixir
defmodule MyModule do
  alias PassiveSupport, as: Ps

  # ...
end
```

The goal of passive_support is to offer natural extensions to the Elixir standard library,
as well as to provide extension modules which help cover the "gaps" in common workflows.

That is to say, these are the things I wished I could find within Elixir's standard library,
wound up implementing myself, and was grateful to have extracted the pattern into a reusable
external function :)

## Contributing

If you like passive_support and have any functions, refactors, or bugfixes you'd like to see
added to it, fork the repository, update the corresponding module files, and submit a pull request!
Generally, doctests are preferred for keeping functions unit tested, but in situations with a lot
of setup, or things that would pollute the top-level test context, add a `describe` and `test`
in the appropriate file within `/test/`.

## Donating

I build and maintain passive_support in my spare time, and also, need to eat and pay rent.
If you appreciate the work I've put into this little library, [support me on Ko-Fi](https://ko-fi.com/thepeoplesbourgeois36330).
I promise that your money will go toward things far more important than single cups of coffee, such as

- toilet paper
- rent
- half-pounds of ground coffee beans
- utilities
- toothpaste
- soap
- rent
- foodstuffs
- internet (which is **not** a utility!)
- rent
- paying off my parking tickets
- a parking permit for the decreased acquisition of parking tickets
- more jokey but probably serious lists like this one
- dear god, rent.

So be a pal, and [help keep me alive!](https://ko-fi.com/thepeoplesbourgeois36330)
