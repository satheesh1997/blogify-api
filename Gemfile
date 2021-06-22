# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.1"

gem "bcrypt", "~> 3.1.7"
gem "blurhash"
gem "bootsnap", ">= 1.4.4", require: false
gem "jwt", "~> 2.2", ">= 2.2.3"
gem "mini_magick"
gem "pg"
gem "puma", "~> 5.0"
gem "rack-cors", "~> 1.1.1"
gem "rails", "~> 6.1.3", ">= 6.1.3.2"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "sqlite3", "~> 1.4"
end

group :development do
  gem "listen", "~> 3.3"
  gem "overcommit"
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
  gem "rubocop-packaging"
  gem "spring"
end



gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
