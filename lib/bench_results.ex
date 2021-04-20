defmodule BenchResults do
  # Note: not captured here is the fact that `:observer` was sitting with
  # a line at roughly 2000MB when I checked in at the end of this suite run.
  # Benchee doesn't seem to see any of this memory usage when I run a profile
  # with`memory_time`; I suspect it's because the used memory is all callstack-
  # based, which their README makes note of not capturing statistics for
  # (Inability? Respect for the VM's privacy?). Regardless of why, I would
  # be remiss if I didn't mention that the iterative version of this,
  # very definitely, has a smaller memory footprint in these (egregiously
  # extreme) outer-limit benchmarks.

  # This is a run of the code using `Stream.Unfold`. As it was part of the
  # process leading me to finally tail-call optimize the function, I decided
  # it was worth including in the results module. Already, according to
  # `:observer`, I've cut the Carrier Size down to literally 50% (!!!) of what
  # it was in the body-recursive form.



end
