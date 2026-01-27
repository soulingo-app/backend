# Gemfile - ZATEN DOĞRU, DEĞİŞTİRMEYE GEREK YOK

source "https://rubygems.org"

ruby "3.4.7"

gem "rails", "~> 8.1.2"
gem "pg", "~> 1.5"
gem "puma", "~> 7.2"

# Authentication
gem "bcrypt", "~> 3.1.7"
gem "jwt"

# API
gem "httparty"
gem "rack-cors"

# Background Jobs
gem "sidekiq"
gem "redis"

# JSON serialization
gem "active_model_serializers"

# Environment variables
gem "dotenv-rails"
# veya en son versiyon
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "pry-rails"
end

group :development do
  gem "spring"
end