#!/bin/sh
set -e

echo "Running pre-push checks..."

echo "-> RuboCop"
bin/rubocop --format progress

echo "-> Brakeman"
bin/brakeman --no-pager -q

echo "-> bundler-audit"
bin/bundler-audit

echo "-> RSpec"
bundle exec rspec

echo "All checks passed."
