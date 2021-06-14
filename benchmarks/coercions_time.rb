# frozen_string_literal: true

require "benchmark/ips"
require "dry/types"
require "active_model"
require "active_support/core_ext/time/zones"
require 'pry'

::Time.zone_default = "Moscow"
am = ActiveModel::Type::Time.new
dry = Dry::Types["params.time"]

["2020-01-20 19:40:22", "2021-02-03T00:10:54.597+03:00", "Thu Nov 29 14:33:20 2001"].each do |d|
  Benchmark.ips do |x|
    x.report("DRY #{d}") do |n|
      while n > 0
        dry[d]
        n -= 1
      end
    end

    x.report("AM #{d}") do |n|
      while n > 0
        am.cast(d)
        n -= 1
      end
    end

    x.compare!
  end
end


# before
#
# Comparison:
# AM 2020-01-20 19:40:22:   130660.9 i/s
# DRY 2020-01-20 19:40:22:    58853.9 i/s - 2.22x  (± 0.00) slower
#
# Comparison:
# DRY 2021-02-03T00:10:54.597+03:00:    52110.0 i/s
# AM 2021-02-03T00:10:54.597+03:00:    39652.9 i/s - 1.31x  (± 0.00) slower
#
# Comparison:
# DRY Thu Nov 29 14:33:20 2001:    44819.1 i/s
# AM Thu Nov 29 14:33:20 2001:    33064.5 i/s - 1.36x  (± 0.00) slower

# after
#
# Comparison:
# DRY 2020-01-20 19:40:22:   190951.9 i/s
# AM 2020-01-20 19:40:22:   131920.6 i/s - 1.45x  (± 0.00) slower
#
# Comparison:
# DRY 2021-02-03T00:10:54.597+03:00:   157549.5 i/s
# AM 2021-02-03T00:10:54.597+03:00:    40502.8 i/s - 3.89x  (± 0.00) slower
#
# Comparison:
# DRY Thu Nov 29 14:33:20 2001:    44376.3 i/s
# AM Thu Nov 29 14:33:20 2001:    33955.3 i/s - 1.31x  (± 0.00) slower
