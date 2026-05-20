# Task

Full development cycle for a single task. Reads context, plans, branches, implements, commits, reviews, and opens a PR.

A senior engineer doesn't stop to ask for help on problems they can solve themselves. This command follows that principle: investigate, diagnose, fix, and continue. Only stop when a **human decision** is genuinely required.

## Usage

```
/task Setup RSpec and testing infrastructure
/task Add deployment frequency endpoint
/task Fix JWT token expiry bug
```

## When to stop and ask vs. when to solve autonomously

**Solve autonomously — never ask about these:**
- Environment issues (wrong Ruby version, missing Node, conflicting version managers, OpenSSL errors, missing system deps)
- Dependency conflicts (wrong gem/package versions, lock file issues)
- Linter errors and autofix
- Test failures caused by setup or config issues
- Missing directories or files
- CI config that needs updating

**Stop and ask — human decision required:**
- Ambiguous requirements ("what should happen when X?")
- Architecture choices with real tradeoffs ("service object or concern?")
- Behaviour that could break existing users
- Anything that requires a secret, credential, or external account

---

## Steps

### 1. Load context

Read `CLAUDE.md`. If it doesn't exist, stop: "No CLAUDE.md found. Run /init first."

Also read `CLAUDE.local.md` and relevant `.claude/rules/` files.

### 2. Understand the task

Restate in one sentence. If genuinely ambiguous, ask one question. If clear, proceed.

### 3. Plan

Check before writing anything:
- What needs to be created or changed
- Whether similar code already exists — never duplicate
- The right abstraction for the stack (service, query, middleware, handler, module, etc.)
- What tests will be written

Present the plan:

```
## Plan: [task name]

**What:** [one sentence]

**Files to create:**
- [file]

**Files to change:**
- [file]

**Tests:**
- [what will be tested]

Proceed?
```

Wait for confirmation, then execute completely.

### 4. Create branch

```sh
git checkout main && git pull origin main
git checkout -b [type]/[short-description]
```

Types: `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`, `perf/`

### 5. Fix the environment first

Before writing any feature code, ensure the environment works.

**Detect the stack and fix accordingly:**

**Ruby:**
- If rbenv and rvm conflict → remove rvm: `rvm implode --force` or disable it in shell profile
- If openssl errors → `gem pristine openssl` or recompile: `gem install openssl -- --with-openssl-dir=$(brew --prefix openssl@3)`
- If wrong Ruby version → check `.ruby-version`, set with rbenv: `rbenv local [version]`
- If `bundle install` fails → read the error, fix the specific gem conflict, retry

**Node/JS:**
- If nvm and n conflict → pick one, remove the other from PATH
- If wrong Node version → check `.nvmrc` or `.node-version`, switch: `nvm use [version]`
- If `npm install` / `yarn` / `pnpm` fails → read the error, fix lockfile or version conflict

**Python:**
- If wrong Python version → check `.python-version`, use pyenv: `pyenv local [version]`
- If virtualenv issues → recreate: `python -m venv .venv && source .venv/bin/activate`
- If `pip install` fails → upgrade pip first, then retry

**PHP:**
- If wrong PHP version → check `.php-version`, switch with phpenv or brew
- If `composer install` fails → read the error, fix version constraint

**Go:**
- If wrong Go version → check `go.mod`, install correct version
- If module issues → `go mod tidy`

**General rule:** Read the full error. Identify the root cause. Fix it. Retry. Only ask if the fix requires a credential, external service, or a business decision.

### 6. Implement

Write the code following the plan and the rules in `CLAUDE.md`.

- Write the core logic first, then the interface (controller/handler/route), then the tests
- Run tests incrementally: `[test command] [specific file]`
- Fix linter errors inline as you go

### 7. Verify

Full suite must pass before committing:

```sh
[lint command]
[test command]
```

If anything fails: read the error, fix it, retry. Do not ask. Do not skip.

### 8. Commit

```sh
git add [specific files]
git commit -m "[type(scope): description]"
```

Conventional Commits: `feat(metrics): add deployment frequency endpoint`

### 9. Self-review

Before opening a PR, review your own changes:

- Right abstraction? Logic in the right layer?
- Duplication? Does similar code already exist?
- Tests cover success, failure, and edge cases?
- Security: unvalidated input? exposed sensitive data?
- Performance: N+1 queries? unbounded results?

```
--- CRITICAL (fix before PR) ---
--- CONCERN (should fix) ---
--- NITPICK (optional) ---
--- VERDICT: APPROVED / NEEDS CHANGES ---
```

Fix any CRITICAL before continuing.

### 10. Open PR

```sh
gh pr create --title "[type]: [description]" --body "$(cat <<'EOF'
## What
[what was built]

## Why
[why it was needed]

## How
[key decisions]

## Testing
[how to verify]

## Checklist
- [ ] Tests pass
- [ ] Linter clean
- [ ] No debug code or secrets
EOF
)"
```

### 11. Report

```
✅ Branch: chore/base-setup
✅ Commits: 1
✅ Tests: 12 examples, 0 failures
✅ Linter: clean
✅ PR: https://github.com/org/repo/pull/1

Next: /ship when CI is green.
```
