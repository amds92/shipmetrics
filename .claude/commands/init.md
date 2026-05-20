# Init

Investigate the project and generate a production-ready Claude Code environment. Covers CLAUDE.md, rules, hooks, settings, output style, and spec template.

## When to use

- Starting to work on an existing project for the first time
- Onboarding Claude Code onto a project that has no CLAUDE.md
- Refreshing an outdated setup after major architectural changes

## Steps

### 1. Investigate the project

Read the following (in parallel where possible):

**Structure:**
- Root directory listing
- `README.md`, `docs/`, `wiki/` if present
- `package.json` / `Gemfile` / `composer.json` / `requirements.txt` / `go.mod` / `Cargo.toml` — whichever exists
- `Dockerfile`, `docker-compose.yml` if present
- CI config: `.github/workflows/`, `.circleci/`, `Jenkinsfile`
- Database config: `config/database.yml`, `.env.example`, `docker-compose.yml`

**Codebase patterns:**
- List directories under `app/`, `src/`, `lib/` — understand the structure
- Read 2-3 representative files from each major directory to understand patterns
- Look for base classes: `ApplicationController`, `ApplicationService`, `BaseModel`, etc.
- Look for existing conventions: how are services named? jobs? tests?
- Find the test directory and read 1-2 test files to understand testing patterns

**Tech detection:**
- Language and version
- Framework and version
- Database(s)
- Background job system
- Cache layer
- External services (look for client files, API wrappers)
- Test framework and linter

### 2. Hunt for gotchas

While reading the code, actively look for non-obvious traps:
- Memoized methods that go stale after writes
- Methods that behave differently for certain record types
- Test setup requirements not in the README (local services, seeds, env vars)
- Places where the codebase diverges from framework conventions
- Any `# TODO`, `# FIXME`, `# HACK`, `# WARNING` comments
- Any `raise NotImplementedError` or `raise "do not use"` markers
- Any method named `legacy_`, `old_`, `deprecated_`
- Git log: `git log --oneline -20` — recent commits reveal active work and known issues

These become the "Things that will bite you" section — the most valuable part of the CLAUDE.md.

### 3. Ask targeted questions

After investigating, ask only what you couldn't determine from the code:

- "I see you have both `app/services/` and `app/use_cases/` — which should new business logic go in?"
- "What's the branch naming convention? I see `feature/`, `feat/`, and `fix/` in git history."
- "Is there a staging environment or does everything go straight to production?"
- "Any known tech debt or areas Claude should avoid touching?"

Do not ask what you can already read from the code.

### 4. Generate CLAUDE.md

**Rules for the generated file:**
- Under 150 lines — every line must pass the test: "would removing this cause Claude to make mistakes?"
- Specific, not vague — "Run `bundle exec rspec`" not "Run the tests"
- No standard conventions — don't explain what Rails is, don't list what REST means
- Use WHAT / WHY / HOW structure

**Template to follow:**

```markdown
# [Project Name]

[One line: what this project does]

## Stack
- Language: [e.g. Ruby 3.3]
- Framework: [e.g. Rails 8.1]
- Database: [e.g. PostgreSQL 16]
- Jobs: [e.g. Sidekiq]
- Tests: [e.g. RSpec]
- Lint: [e.g. RuboCop]

## Structure
[Only what's non-obvious. If it's standard Rails, skip it.]
- `app/services/` — business logic, always use service objects
- `app/clients/` — all external API calls go here, nowhere else
- [etc.]

## Commands
\`\`\`sh
# Install
[command]

# Test
[command]

# Lint
[command]

# Single test
[command]
\`\`\`

## Git flow
- Branch: `feat/`, `fix/`, `chore/`, `refactor/`
- Commits: Conventional Commits (`feat:`, `fix:`, etc.)
- Never push to main directly

## Rules
- [Non-obvious rule 1 — e.g. "All monetary values in pence, never floats"]
- [Non-obvious rule 2 — e.g. "Never hard-delete records, use soft deletes"]
- [Non-obvious rule 3 — e.g. "Background jobs must be idempotent"]

## IMPORTANT
- [Critical constraint — e.g. "Do NOT touch LegacyPaymentService — rewrite in progress"]
- [Critical constraint — e.g. "Always check existing services before creating new ones"]

## Things that will bite you
- [Non-obvious gotcha found in the code — e.g. "User#full_name returns nil for OAuth users"]
- [Test environment quirk — e.g. "Redis must be running before rspec"]
- [Stale memoization trap — e.g. "Order#total is memoized — call reload after payment updates"]
```

### 5. Generate .claude/rules/ files

For larger concerns, generate path-scoped rule files instead of bloating CLAUDE.md:

```
.claude/rules/
├── testing.md          # Test conventions (loads when editing spec/ files)
├── api.md              # API/controller rules (loads when editing controllers)
└── security.md         # Security rules (loads when editing auth/payment code)
```

Each rule file uses frontmatter to scope to specific paths:

```markdown
---
paths:
  - "spec/**/*"
---
# Testing rules
- Use doubles for external dependencies, never real HTTP calls in unit tests
- Test behaviour, not implementation — avoid testing private methods
- Every service object needs a spec that covers success and failure paths
```

### 6. Generate supporting environment files

These files make Claude Code behave correctly without the developer having to ask.

**`.claude/settings.json`** — shared permissions, committed to the repo:
```json
{
  "permissions": {
    "allow": [
      "Bash(git status)", "Bash(git diff*)", "Bash(git log*)",
      "Bash(git add*)", "Bash(git commit*)", "Bash(git push*)",
      "Bash(git pull*)", "Bash(git checkout*)", "Bash(git branch*)",
      "Bash(git merge*)", "Bash(git rebase*)", "Bash(git fetch*)",
      "Bash(gh run list*)", "Bash(gh run view*)",
      "Bash(gh pr create*)", "Bash(gh pr view*)",
      "Bash(ls*)", "Bash(find*)", "Bash(grep*)"
    ]
  }
}
```
Add the project's own test/lint commands (e.g. `"Bash(bundle exec*)"` for Ruby).

**`.claude/output-styles/writing.md`** — eliminates "be more concise" prompts forever:
```markdown
# Writing style
- Direct and technical — no filler phrases
- Code first, explanation after (if needed at all)
- Short by default — expand only when complexity demands it
- Never explain Git, Rails, REST, or other basics
- Never end with "Let me know if you need anything else"
```

**`.claude/hooks/pre-push.sh`** — auto-detect stack and run lint + tests before every push:
Generate a script that detects the language (Gemfile → Ruby/RuboCop/RSpec, package.json → Node/ESLint/Jest, etc.) and runs the appropriate checks. Make it executable (`chmod +x`).

**`CLAUDE.local.md`** — personal overrides, gitignored. Generate a stub:
```markdown
# Local overrides — DO NOT COMMIT
## My preferences
- [personal preference 1]
## Local environment notes
- [local env quirk]
```
Add `CLAUDE.local.md` to `.gitignore` if not already there.

**`specs/feature.md.template`** — contract template for features before coding starts.

### 7. Present for review before writing

Show everything that will be created:

```
Files to create:
  CLAUDE.md                          (N lines)
  .claude/rules/testing.md
  .claude/rules/api.md
  .claude/settings.json
  .claude/output-styles/writing.md
  .claude/hooks/pre-push.sh
  CLAUDE.local.md                    (gitignored)
  specs/feature.md.template
```

Ask: "Does this look accurate? Anything to add or remove before I write the files?"

Only write files after confirmation.

### 8. Write the files

Create all files. Then:

```sh
chmod +x .claude/hooks/pre-push.sh

# Add CLAUDE.local.md to .gitignore if missing
grep -q "CLAUDE.local.md" .gitignore || echo "CLAUDE.local.md" >> .gitignore
grep -q "settings.local.json" .gitignore || echo ".claude/settings.local.json" >> .gitignore
grep -q "mcp-calls.log" .gitignore || echo ".claude/mcp-calls.log" >> .gitignore
```

### 9. Commit and push

After writing all files, commit and push immediately — the project should never be in a state where the environment is set up locally but not on GitHub.

```sh
git add CLAUDE.md .claude/ specs/ .gitignore
git commit -m "chore: add Claude Code engineering environment

- CLAUDE.md with stack, commands, rules, and gotchas
- .claude/rules/ scoped to spec/ and app/
- .claude/settings.json with shared permissions
- .claude/output-styles/writing.md for consistent output
- .claude/hooks/pre-push.sh for automated quality gates
- specs/feature.md.template for feature contracts"
git push
```

If there is no remote configured yet, say so clearly:
```
⚠️  No remote configured. Run:
    git remote add origin <your-repo-url>
    git push -u origin main
```

End with:
```
✅ CLAUDE.md ([N] lines)
✅ .claude/rules/testing.md
✅ .claude/rules/api.md
✅ .claude/settings.json
✅ .claude/output-styles/writing.md
✅ .claude/hooks/pre-push.sh
✅ CLAUDE.local.md (gitignored)
✅ specs/feature.md.template
✅ .gitignore updated
✅ Committed and pushed to main

Claude is now ready to work as a senior engineer on this project.
Run /task to start your first task.
```

## What NOT to put in CLAUDE.md

- Standard language conventions Claude already knows
- Detailed API documentation (link to docs instead)
- File-by-file descriptions of the codebase
- Long explanations or tutorials
- Information that changes frequently
- Self-evident practices like "write clean code"
