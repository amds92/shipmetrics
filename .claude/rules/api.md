---
paths:
  - "app/controllers/**/*"
  - "config/routes.rb"
---
# API / Controller rules
- All controllers live under `app/controllers/api/v1/` and inherit from `Api::V1::BaseController`
- Controller body: authenticate → find record → call service → serialize → respond. Nothing else.
- Routes always nested: `namespace :api do namespace :v1 do ... end end`
- Never build JSON manually in controllers — always delegate to serializers
- Never put business logic or query construction in controllers
- HTTP status codes: 201 create, 200 show/update, 204 delete, 422 validation error, 401 auth failure, 404 not found
- Services return a result object or raise — controllers handle only the HTTP surface
