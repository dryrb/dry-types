# frozen_string_literal: true

source "https://rubygems.org"

eval_gemfile "Gemfile.devtools"

gemspec

gem "dry-logic", github: "dry-rb/dry-logic", branch: "master" if ENV["DRY_LOGIC_FROM_MASTER"].eql?("true")

group :test do
  gem "dry-struct"
end

group :tools do
  gem "pry-byebug", platform: :mri
end

group :benchmarks do
  platform :mri do
    gem "activemodel"
    gem "attrio"
    gem "benchmark-ips"
    gem "fast_attributes"
    gem "hotch"
    gem "virtus"
  end
end
