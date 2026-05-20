# ShipMetrics

Self-hosted DORA metrics API — connects to GitHub and calculates deployment frequency,
lead time for changes, change failure rate, and time to restore.

## Stack
- Language: Ruby 3.3.11
- Framework: Rails 8.1.3 (API-only)
- Database: PostgreSQL + SolidQueue / SolidCache / SolidCable
- Auth: JWT
- Tests: RSpec
- Lint: RuboCop (rubocop-rails-omakase)
- Security: Brakeman, bundler-audit
- Deploy: Kamal + Thruster

## Structure
- `app/controllers/api/v1/` — thin controllers only, no business logic
- `app/services/` — all business logic (DORA calculations, GitHub integration)
- `app/queries/` — complex ActiveRecord queries
- `app/serializers/` — JSON output formatting
- All routes namespaced under `/api/v1/`

## Commands
```sh
bundle install
bundle exec rspec                                  # full suite
bundle exec rspec spec/path/to/file_spec.rb        # single file
bin/rubocop                                        # lint
bin/brakeman --no-pager && bin/bundler-audit       # security
bin/rails db:create db:migrate                     # DB setup
```

## Git flow
- Branch: `feat/`, `fix/`, `chore/`, `refactor/`
- Commits: Conventional Commits (`feat:`, `fix:`, etc.)
- Never push to main directly

## Rules
- Controllers: authenticate → find → call service → serialize → respond. Nothing else.
- DORA calculations and GitHub API calls go in `app/services/`, nowhere else
- Complex queries go in `app/queries/`, not inline in models or controllers
- JSON output always via `app/serializers/`
- JWT required on all endpoints except `/up`

## Things that will bite you
- SolidQueue/SolidCache/SolidCable each use a separate production database — all four
  need `db:migrate` independently in production
- Production DB password via `SHIPMETRICS_DATABASE_PASSWORD` (not `DATABASE_URL`)
- GitHub API has rate limits — never fetch raw GitHub data in the request cycle;
  use SolidQueue background jobs for data ingestion
- No RSpec job in CI yet — `.github/workflows/ci.yml` only runs lint and security scans
