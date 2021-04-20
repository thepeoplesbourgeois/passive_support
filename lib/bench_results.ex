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

  def tail_recursive, do: %Benchee.Suite{
    configuration: %Benchee.Configuration{
      after_each: nil,
      after_scenario: nil,
      assigns: %{},
      before_each: nil,
      before_scenario: nil,
      formatters: [Benchee.Formatters.Console],
      inputs: [
        {"1: 2^(2^15)", {2, 32768}},
        {"2: 2^(2^16)", {2, 65536}},
        {"3: 2^(2^17)", {2, 131072}},
        {"4: 2^(2^18)", {2, 262144}},
        {"5: 2^(2^19)", {2, 524288}},
        {"6: 3^(3^9)", {3, 19683}},
        {"7: 3^(3^10)", {3, 59049}},
        {"8: 3^(3^11)", {3, 177147}},
        {"9: 3^(3^12)", {3, 531441}},
        {"10: 5^(5^4)", {5, 625}},
        {"11: 5^(5^5)", {5, 3125}},
        {"12: 5^(5^6)", {5, 15625}},
        {"13: 5^(5^7)", {5, 78125}},
        {"14: 5^(5^8)", {5, 390625}},
        {"15: 7^(7^2)", {7, 49}},
        {"16: 7^(7^3)", {7, 343}},
        {"17: 7^(7^4)", {7, 2401}},
        {"18: 7^(7^5)", {7, 16807}},
        {"19: 7^(7^6)", {7, 117649}},
        {"20: 11^(11^2)", {11, 121}},
        {"21: 11^(11^3)", {11, 1331}},
        {"22: 11^(11^4)", {11, 14641}},
        {"23: 11^(11^5)", {11, 161051}}
      ],
      load: false,
      measure_function_call_overhead: true,
      memory_time: 0.0,
      parallel: 1,
      percentiles: '2c',
      pre_check: false,
      print: %{benchmarking: true, configuration: true, fast_warning: true},
      save: false,
      time: 1.5e10,
      title: nil,
      unit_scaling: :best,
      warmup: 3.0e9
    },
    scenarios: [
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {2, 32768},
        input_name: "1: 2^(2^15)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [3.739e5, 2.859e5, 2.849e5, 2.839e5, 2.839e5, 2.849e5, 2.839e5,
           2.839e5, 2.839e5, 2.839e5, 2.839e5, 2.839e5, 2.839e5, 2.839e5, 2.879e5,
           2.839e5, 2.829e5, 2.839e5, 3.059e5, 3.509e5, 3.579e5, 1.0889e6,
           4.409e5, 3.189e5, 2.859e5, 2.839e5, 2.839e5, 2.839e5, 2.829e5, 2.839e5,
           2.829e5, 2.839e5, 2.839e5, 2.839e5, 2.839e5, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 324270.8646945563,
            ips: 3083.841654852156,
            maximum: 7.2119e6,
            median: 2.849e5,
            minimum: 2.819e5,
            mode: 2.839e5,
            percentiles: %{50 => 2.849e5, 99 => 7.399e5},
            relative_less: nil,
            relative_more: nil,
            sample_size: 45704,
            std_dev: 115334.19748570527,
            std_dev_ips: 1096.8373701115108,
            std_dev_ratio: 0.3556724024353627
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {2, 65536},
        input_name: "2: 2^(2^16)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [1.2089e6, 1.2819e6, 1.2409e6, 1.3919e6, 1.7899e6, 1.1329e6,
           1.1669e6, 1.1159e6, 1.1159e6, 1.1149e6, 1.1139e6, 1.1169e6, 1.2679e6,
           1.2419e6, 1.2559e6, 1.1839e6, 1.1219e6, 1.1179e6, 1.1159e6, 1.1159e6,
           1.1159e6, 1.2309e6, 1.1149e6, 1.1169e6, 1.1159e6, 1.1149e6, 1.1169e6,
           1.1159e6, 1.2089e6, 1.1499e6, 1.1239e6, 1.1209e6, 1.1219e6, 1.1159e6,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 1290560.2564102565,
            ips: 774.857272283852,
            maximum: 1.33989e7,
            median: 1.1299e6,
            minimum: 1.1089e6,
            mode: 1.1159e6,
            percentiles: %{50 => 1.1299e6, 99 => 2928099.999999997},
            relative_less: nil,
            relative_more: nil,
            sample_size: 11544,
            std_dev: 423776.1224822645,
            std_dev_ips: 254.43679107165272,
            std_dev_ratio: 0.328366010325635
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {2, 131072},
        input_name: "3: 2^(2^17)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [9.2039e6, 1.38909e7, 1.14719e7, 1.26099e7, 4.6079e6,
           1.15149e7, 4.9839e6, 6.5909e6, 5.2249e6, 4.5099e6, 5.6259e6, 5.2289e6,
           4.8309e6, 5.6849e6, 8.3089e6, 5.9599e6, 8.0839e6, 5.8359e6, 6.6489e6,
           8.6919e6, 4.9949e6, 1.34759e7, 9.3479e6, 6.3299e6, 5.7279e6, 8.5219e6,
           4.4699e6, 6.8879e6, 4.5089e6, 4.5139e6, 6.2239e6, 5.1439e6, 4.4439e6,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 5129709.605488851,
            ips: 194.94280902957703,
            maximum: 1.094219e8,
            median: 4.6149e6,
            minimum: 4.4239e6,
            mode: 4.4349e6,
            percentiles: %{50 => 4.6149e6, 99 => 1.14711e7},
            relative_less: nil,
            relative_more: nil,
            sample_size: 2915,
            std_dev: 2561868.959300946,
            std_dev_ips: 97.35793440576488,
            std_dev_ratio: 0.49941793129180556
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {2, 262144},
        input_name: "4: 2^(2^18)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [1.83119e7, 2.08269e7, 1.93699e7, 1.78249e7, 1.83559e7,
           1.78509e7, 2.02459e7, 1.85209e7, 1.80499e7, 1.79479e7, 1.81379e7,
           1.81079e7, 1.85689e7, 1.79839e7, 1.84219e7, 1.79479e7, 2.27029e7,
           1.88119e7, 1.83439e7, 1.81419e7, 1.81289e7, 2.03039e7, 1.87169e7,
           1.79089e7, 1.79969e7, 1.79809e7, 2.01949e7, 1.95719e7, 1.80309e7,
           1.78249e7, 1.82019e7, 1.92149e7, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 18827102.26130653,
            ips: 53.114918383122635,
            maximum: 2.61929e7,
            median: 1.83009e7,
            minimum: 1.77859e7,
            mode: [1.80729e7, 1.80309e7],
            percentiles: %{50 => 1.83009e7, 99 => 23796910.0},
            relative_less: nil,
            relative_more: nil,
            sample_size: 796,
            std_dev: 1278122.7765730799,
            std_dev_ips: 3.605833017692341,
            std_dev_ratio: 0.06788738696128922
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {2, 524288},
        input_name: "5: 2^(2^19)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [7.29679e7, 7.30339e7, 7.19569e7, 7.32109e7, 7.17009e7,
           7.23039e7, 7.23459e7, 7.36029e7, 7.25499e7, 7.29359e7, 7.23549e7,
           7.25679e7, 7.18039e7, 7.22899e7, 7.19549e7, 7.72619e7, 7.77649e7,
           7.55189e7, 7.30369e7, 7.49899e7, 7.55149e7, 7.59329e7, 7.28619e7,
           7.49979e7, 7.44979e7, 7.41889e7, 7.30329e7, 7.52009e7, 7.60139e7,
           7.15309e7, 7.31639e7, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 74402380.52475247,
            ips: 13.440430171012018,
            maximum: 9.71629e7,
            median: 7.36019e7,
            minimum: 7.15309e7,
            mode: [7.19549e7, 7.43799e7],
            percentiles: %{50 => 7.36019e7, 99 => 81932800.03},
            relative_less: nil,
            relative_more: nil,
            sample_size: 202,
            std_dev: 2734198.3911971576,
            std_dev_ips: 0.4939197145493626,
            std_dev_ratio: 0.036748802550578795
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {3, 19683},
        input_name: "6: 3^(3^9)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [3.639e5, 3.619e5, 3.619e5, 3.759e5, 3.639e5, 4.069e5, 4.039e5,
           4.029e5, 4.109e5, 4.029e5, 3.889e5, 3.619e5, 3.629e5, 3.639e5, 3.629e5,
           3.659e5, 3.629e5, 3.619e5, 3.639e5, 3.619e5, 3.629e5, 3.619e5, 3.629e5,
           3.619e5, 3.619e5, 3.609e5, 3.619e5, 3.619e5, 3.619e5, 3.879e5, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 387247.89566667535,
            ips: 2582.3252009631387,
            maximum: 1.7169e6,
            median: 3.629e5,
            minimum: 3.599e5,
            mode: 3.619e5,
            percentiles: %{50 => 3.629e5, 99 => 6.459e5},
            relative_less: nil,
            relative_more: nil,
            sample_size: 38377,
            std_dev: 56563.93859035034,
            std_dev_ips: 377.19116287547297,
            std_dev_ratio: 0.1460664840875931
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {3, 59049},
        input_name: "7: 3^(3^10)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [4.4709e6, 4.6269e6, 4.1069e6, 4.1949e6, 4.0849e6, 4.3209e6,
           4.0329e6, 4097901.0, 4.0609e6, 4.2859e6, 4.0399e6, 4.0639e6, 4.0349e6,
           4.3309e6, 4.0539e6, 4.0569e6, 4.0409e6, 4.3289e6, 4.0319e6, 4.0439e6,
           4.0679e6, 4.3629e6, 5.6429e6, 4.4709e6, 4.4549e6, 4570901.0, 4.0429e6,
           4.0539e6, 4.2149e6, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 4337647.953002611,
            ips: 230.53968667691876,
            maximum: 7.8159e6,
            median: 4.1749e6,
            minimum: 4.0239e6,
            mode: 4.0319e6,
            percentiles: %{50 => 4.1749e6, 99 => 5.9259e6},
            relative_less: nil,
            relative_more: nil,
            sample_size: 3447,
            std_dev: 428714.52028494346,
            std_dev_ips: 22.78555388800519,
            std_dev_ratio: 0.09883571118033639
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {3, 177147},
        input_name: "8: 3^(3^11)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [3.30529e7, 33181901.0, 3.59449e7, 3.28649e7, 33011901.0,
           3.47439e7, 33509901.0, 3.32689e7, 36550901.0, 3.43309e7, 38615901.0,
           4.07689e7, 34618901.0, 3.33099e7, 3.36009e7, 35987901.0, 3.44929e7,
           32746901.0, 3.29519e7, 33109901.0, 3.29749e7, 33444901.0, 3.28179e7,
           3.30849e7, 33025901.0, 3.31989e7, 32952901.0, 3.32919e7, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 34012031.96145125,
            ips: 29.401360116719452,
            maximum: 49900901.0,
            median: 3.34069e7,
            minimum: 32297901.0,
            mode: [3.32689e7, 33197901.0, 3.33399e7, 3.26649e7, 33174901.0,
             3.28349e7, 32962901.0, 33505901.0, 33730901.0, 3.32319e7, 34551901.0,
             3.31389e7, 3.30579e7, 32581901.0, 32587901.0, 33680901.0, 33384901.0,
             32724901.0, 33627901.0, 33376901.0, # # ...
             ],
            percentiles: %{50 => 3.34069e7, 99 => 40126920.58},
            relative_less: nil,
            relative_more: nil,
            sample_size: 441,
            std_dev: 1727527.6705037556,
            std_dev_ips: 1.4933439792613665,
            std_dev_ratio: 0.050791663152078385
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {3, 531441},
        input_name: "9: 3^(3^12)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [210353902.0, 206748903.0, 205928903.0, 202557902.0,
           208106903.0, 199952903.0, 199957902.0, 199021903.0, 198767903.0,
           206907902.0, 205987903.0, 206606903.0, 212721902.0, 212579903.0,
           203116903.0, 199828902.0, 200580903.0, 200692903.0, 211663902.0,
           204785903.0, 201917903.0, 206722902.0, 204762903.0, 197870903.0,
           197989902.0, 196755903.0, 198305902.0, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 202868781.0135135,
            ips: 4.929294665271282,
            maximum: 224483903.0,
            median: 203126402.5,
            minimum: 194119903.0,
            mode: nil,
            percentiles: %{50 => 203126402.5, 99 => 224483903.0},
            relative_less: nil,
            relative_more: nil,
            sample_size: 74,
            std_dev: 5381681.305730587,
            std_dev_ips: 0.13076380120192516,
            std_dev_ratio: 0.026527892950527966
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {5, 625},
        input_name: "10: 5^(5^4)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [7.9e3, 1.9e3, 2.9e3, 1.9e3, 1.9e3, 1.9e3, 2.9e3, 1.9e3, 1.9e3,
           1.9e3, 1.9e3, 2.9e3, 2.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 2.9e3, 1.9e3,
           1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 2.9e3, 1.9e3, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 2263.9791708704374,
            ips: 441700.1767801281,
            maximum: 1.16759e7,
            median: 1.9e3,
            minimum: 900.0,
            mode: 1.9e3,
            percentiles: %{50 => 1.9e3, 99 => 4.9e3},
            relative_less: nil,
            relative_more: nil,
            sample_size: 4202576,
            std_dev: 7565.679075423817,
            std_dev_ips: 1476056.7712253293,
            std_dev_ratio: 3.341761785076416
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {5, 3125},
        input_name: "11: 5^(5^5)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [4.39e4, 3.89e4, 3.59e4, 2.69e4, 2.69e4, 2.69e4, 2.69e4,
           2.69e4, 2.69e4, 2.59e4, 2.69e4, 2.89e4, 2.59e4, 2.69e4, 2.69e4, 2.69e4,
           2.59e4, 2.79e4, 2.59e4, 2.69e4, 2.69e4, 2.59e4, 2.69e4, 3.09e4, 2.69e4,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 26323.997268339208,
            ips: 37988.15163997661,
            maximum: 4187901.0,
            median: 2.39e4,
            minimum: 2.29e4,
            mode: 2.39e4,
            percentiles: %{50 => 2.39e4, 99 => 5.29e4},
            relative_less: nil,
            relative_more: nil,
            sample_size: 532643,
            std_dev: 10927.5754850821,
            std_dev_ips: 15769.580522023043,
            std_dev_ratio: 0.4151183945845898
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {5, 15625},
        input_name: "12: 5^(5^6)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [6.549e5, 6.869e5, 6.329e5, 6.629e5, 7.159e5, 6.349e5, 7.189e5,
           6.759e5, 6.309e5, 6.349e5, 6.339e5, 6.339e5, 6.339e5, 6.339e5, 6.759e5,
           6.889e5, 7.019e5, 6.319e5, 6.299e5, 6.489e5, 6.659e5, 7.149e5, 7.319e5,
           7.009e5, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 699965.8940849581,
            ips: 1428.6410358711353,
            maximum: 1.28259e7,
            median: 6.419e5,
            minimum: 6.289e5,
            mode: 6.349e5,
            percentiles: %{50 => 6.419e5, 99 => 1.1299e6},
            relative_less: nil,
            relative_more: nil,
            sample_size: 21234,
            std_dev: 180590.48232451794,
            std_dev_ips: 368.5879210926993,
            std_dev_ratio: 0.25799897373656727
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {5, 78125},
        input_name: "13: 5^(5^7)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [1.28909e7, 1.22929e7, 1.23519e7, 12770901.0, 1.25879e7,
           1.24859e7, 1.21059e7, 1.44309e7, 1.34099e7, 12486901.0, 1.23659e7,
           1.23499e7, 1.24449e7, 1.22009e7, 1.29589e7, 14686901.0, 1.23039e7,
           1.32729e7, 1.21639e7, 1.28569e7, 1.20879e7, 12766901.0, 1.30199e7,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 12914578.338222606,
            ips: 77.43187379493081,
            maximum: 1.88229e7,
            median: 1.25489e7,
            minimum: 1.19389e7,
            mode: [1.24509e7, 1.26329e7, 1.22479e7, 1.22599e7, 1.23499e7,
             1.23249e7, 1.23469e7, 1.23349e7, 1.23659e7, 1.22009e7],
            percentiles: %{50 => 1.25489e7, 99 => 16331100.400000017},
            relative_less: nil,
            relative_more: nil,
            sample_size: 1159,
            std_dev: 955818.4030371123,
            std_dev_ips: 5.730795695883933,
            std_dev_ratio: 0.07401080995484198
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {5, 390625},
        input_name: "14: 5^(5^8)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [380098905.0, 394689905.0, 392000905.0, 391855905.0,
           382199905.0, 383845905.0, 378793905.0, 380518905.0, 378854905.0,
           380782905.0, 393293905.0, 393742905.0, 391327905.0, 380214905.0,
           379272905.0, 378939905.0, 380946905.0, 377606905.0, 376857904.0,
           395987906.0, 390934905.0, 386122905.0, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 384752956.28205127,
            ips: 2.599070348057128,
            maximum: 402379906.0,
            median: 382199905.0,
            minimum: 372552905.0,
            mode: nil,
            percentiles: %{50 => 382199905.0, 99 => 402379906.0},
            relative_less: nil,
            relative_more: nil,
            sample_size: 39,
            std_dev: 7463059.27686044,
            std_dev_ips: 0.05041420931425216,
            std_dev_ratio: 0.019397016072280643
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {7, 49},
        input_name: "15: 7^(7^2)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [7.9e3, 900.0, 900.0, 900.0, 900.0, 900.0, 0, 900.0, 900.0, 0,
           900.0, 900.0, 900.0, 900.0, 900.0, 900.0, 0, 900.0, 900.0, 900.0, 0,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 687.2310192007317,
            ips: 1455114.7606274046,
            maximum: 100364901.0,
            median: 900.0,
            minimum: 0,
            mode: 900.0,
            percentiles: %{50 => 900.0, 99 => 900.0},
            relative_less: nil,
            relative_more: nil,
            sample_size: 8328693,
            std_dev: 62049.629935957695,
            std_dev_ips: 131381340.31884804,
            std_dev_ratio: 90.28933241128013
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {7, 343},
        input_name: "16: 7^(7^3)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [7.9e3, 1.9e3, 2.9e3, 1.9e3, 2.9e3, 1.9e3, 1.9e3, 1.9e3, 2.9e3,
           1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 900.0, 900.0, 1.9e3,
           900.0, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 1619.3296305966749,
            ips: 617539.4935690331,
            maximum: 59867901.0,
            median: 1.9e3,
            minimum: 900.0,
            mode: 900.0,
            percentiles: %{50 => 1.9e3, 99 => 3.9e3},
            relative_less: nil,
            relative_more: nil,
            sample_size: 5235497,
            std_dev: 31734.5722964962,
            std_dev_ips: 12102138.646957932,
            std_dev_ratio: 19.59735170460813
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {7, 2401},
        input_name: "17: 7^(7^4)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [3.49e4, 3.19e4, 2.89e4, 2.09e4, 1.99e4, 1.99e4, 1.99e4,
           2.09e4, 2.09e4, 1.99e4, 2.09e4, 2.09e4, 1.99e4, 1.99e4, 1.99e4, 1.99e4,
           1.99e4, 2.09e4, 1.99e4, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 20595.055384449774,
            ips: 48555.344053847344,
            maximum: 2.97189e7,
            median: 1.89e4,
            minimum: 1.69e4,
            mode: 1.79e4,
            percentiles: %{50 => 1.89e4, 99 => 4.49e4},
            relative_less: nil,
            relative_more: nil,
            sample_size: 668852,
            std_dev: 39304.677409095544,
            std_dev_ips: 92665.55000211777,
            std_dev_ratio: 1.9084521345241152
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {7, 16807},
        input_name: "18: 7^(7^5)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [6.239e5, 6.269e5, 6.359e5, 6.449e5, 6.279e5, 7.109e5, 6.999e5,
           6.899e5, 6.389e5, 6.269e5, 6.229e5, 6.229e5, 6.269e5, 6.269e5, 6.219e5,
           6.269e5, 6.279e5, 6.219e5, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 679119.9476640635,
            ips: 1472.4939290027517,
            maximum: 3.0639e6,
            median: 6.279e5,
            minimum: 6.189e5,
            mode: 6.239e5,
            percentiles: %{50 => 6.279e5, 99 => 1.1979e6},
            relative_less: nil,
            relative_more: nil,
            sample_size: 21897,
            std_dev: 117460.10701015372,
            std_dev_ips: 254.68151107530377,
            std_dev_ratio: 0.17295929447246491
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {7, 117649},
        input_name: "19: 7^(7^6)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [51496901.0, 54523901.0, 5.11219e7, 53661901.0, 50858901.0,
           5.46459e7, 51248901.0, 55510901.0, 50838901.0, 5.41179e7, 52659901.0,
           52603901.0, 5.16279e7, 53063901.0, 51413901.0, 5.14539e7, 51288901.0,
           # # ...
          ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 52685234.02105263,
            ips: 18.98065024443865,
            maximum: 60082901.0,
            median: 52176901.0,
            minimum: 5.06309e7,
            mode: [5.18479e7, 51706901.0, 50973901.0, 50901901.0, 52925901.0],
            percentiles: %{50 => 52176901.0, 99 => 59073320.13999999},
            relative_less: nil,
            relative_more: nil,
            sample_size: 285,
            std_dev: 1741116.5792131822,
            std_dev_ips: 0.6272635101446703,
            std_dev_ratio: 0.03304752482483887
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {11, 121},
        input_name: "20: 11^(11^2)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [6.9e3, 1.9e3, 1.9e3, 900.0, 900.0, 900.0, 1.9e3, 1.9e3, 1.9e3,
           1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, 1.9e3, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 925.3404923184802,
            ips: 1080683.2817771297,
            maximum: 38951901.0,
            median: 900.0,
            minimum: 0,
            mode: 900.0,
            percentiles: %{50 => 900.0, 99 => 1.9e3},
            relative_less: nil,
            relative_more: nil,
            sample_size: 6913736,
            std_dev: 18231.442386949995,
            std_dev_ips: 21292070.49060886,
            std_dev_ratio: 19.702414990259786
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {11, 1331},
        input_name: "21: 11^(11^3)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [1.99e4, 1.09e4, 9.9e3, 9.9e3, 9.9e3, 9.9e3, 9.9e3, 9.9e3,
           9.9e3, 9.9e3, 1.09e4, 9.9e3, 9.9e3, 9.9e3, 9.9e3, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 11560.198289767171,
            ips: 86503.70650520567,
            maximum: 4.67309e7,
            median: 9.9e3,
            minimum: 8.9e3,
            mode: 9.9e3,
            percentiles: %{50 => 9.9e3, 99 => 2.89e4},
            relative_less: nil,
            relative_more: nil,
            sample_size: 1127098,
            std_dev: 61069.66443067017,
            std_dev_ips: 456977.6569454059,
            std_dev_ratio: 5.282752328282091
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {11, 14641},
        input_name: "22: 11^(11^4)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [1.2479e6, 1.1809e6, 1.1719e6, 1.1809e6, 1.1709e6, 1.1879e6,
           1.4929e6, 1.3779e6, 1.1729e6, 1.1779e6, 1.1719e6, 1.1819e6, 1.1809e6,
           1.2059e6, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 1392877.0286196866,
            ips: 717.9384679715624,
            maximum: 2.65699e7,
            median: 1.2259e6,
            minimum: 1.1699e6,
            mode: 1.1799e6,
            percentiles: %{50 => 1.2259e6, 99 => 3275740.42},
            relative_less: nil,
            relative_more: nil,
            sample_size: 10657,
            std_dev: 588142.8497481605,
            std_dev_ips: 303.1497884024011,
            # ...
          }
        },
        tag: nil
      },
      %Benchee.Scenario{
        after_each: nil,
        after_scenario: nil,
        before_each: nil,
        before_scenario: nil,
        function: "#Function<0.42504656/1 in Benchmark.maths/0>",
        input: {11, 161051},
        input_name: "23: 11^(11^5)",
        job_name: "tail-call recursive",
        memory_usage_data: %Benchee.CollectionData{
          samples: [],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: nil,
            ips: nil,
            maximum: nil,
            median: nil,
            minimum: nil,
            mode: nil,
            percentiles: nil,
            relative_less: nil,
            relative_more: nil,
            sample_size: 0,
            std_dev: nil,
            std_dev_ips: nil,
            std_dev_ratio: nil
          }
        },
        name: "tail-call recursive",
        run_time_data: %Benchee.CollectionData{
          samples: [126950902.0, 128673902.0, 126963901.0, 274632904.0,
           759028910.0, 235840903.0, 165983902.0, 163228902.0, 174544902.0,
           219269903.0, 251663904.0, 393227905.0, 206271902.0, # # ...
           ],
          statistics: %Benchee.Statistics{
            absolute_difference: nil,
            average: 183496963.36585367,
            ips: 5.4496814642442555,
            maximum: 759028910.0,
            median: 146409402.0,
            minimum: 120393902.0,
            mode: nil,
            percentiles: %{50 => 146409402.0, 99 => 759028910.0},
            relative_less: nil,
            relative_more: nil,
            sample_size: 82,
            std_dev: 90596340.52314419,
            # ...
          }
        },
        tag: nil
      }
    ],
    system: %{
      available_memory: "16 GB",
      cpu_speed: "Intel(R) Core(TM) i5-4278U CPU @ 2.60GHz",
      elixir: "1.11.4",
      erlang: "23.3.1",
      num_cores: 4,
      os: :macOS
    }
  }


end
