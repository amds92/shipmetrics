---
paths:
  - "spec/**/*"
---
# Testing rules
- RSpec only — no minitest
- Use doubles/stubs for all GitHub API calls; never make real HTTP requests in unit tests
- Service objects: cover success path, failure path, and edge cases (empty data, rate limits, missing GitHub resources)
- Query objects: test with real DB records via FactoryBot, not mocks
- Controllers: request specs only (no controller specs); test 401 on missing/invalid JWT and happy path
- DORA metric specs must use deterministic fixture data so calculations are verifiable
- Stub JWT authentication in non-auth specs rather than generating real tokens each time
