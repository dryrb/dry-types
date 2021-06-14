# frozen_string_literal: true

require "active_model"
require "benchmark/ips"
require "dry/types"

am = ActiveModel::Type::Date.new
dry = Dry::Types["params.date"]

["2020-01-20", "3rd Feb 2001"].each do |d|
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
#        AM 2020-01-20:   712594.2 i/s
#       DRY 2020-01-20:   234735.9 i/s - 3.04x  (± 0.00) slower
#
# Comparison:
#     DRY 3rd Feb 2001:   148000.4 i/s
#      AM 3rd Feb 2001:   140262.5 i/s - same-ish: difference falls within error

# after
#
# Comparison:
#        AM 2020-01-20:   694511.8 i/s
#       DRY 2020-01-20:   692906.6 i/s - same-ish: difference falls within error
#
# Comparison:
#     DRY 3rd Feb 2001:   141146.9 i/s
#      AM 3rd Feb 2001:   139686.5 i/s - same-ish: difference falls within error
