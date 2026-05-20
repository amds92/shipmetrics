# Commit

Create a semantic, meaningful commit. A good commit message is a letter to the next developer (which might be you in 6 months).

## Commit message format

Following [Conventional Commits](https://www.conventionalcommits.org):

```
<type>(<scope>): <short description>

[optional body — the WHY, not the WHAT]

[optional footer — breaking changes, issue references]
```

**Types:**
| Type | When |
|------|------|
| `feat` | New feature or behaviour |
| `fix` | Bug fix |
| `chore` | Maintenance, deps, tooling |
| `refactor` | Code change that doesn't fix a bug or add a feature |
| `test` | Adding or fixing tests |
| `docs` | Documentation only |
| `perf` | Performance improvement |
| `ci` | CI/CD configuration |

**Rules:**
- Subject line: max 72 chars, imperative mood ("Add" not "Added", "Fix" not "Fixed")
- Body: explain WHY, not WHAT (the diff shows what)
- Reference issues: `Closes #123` or `Refs #123`

**Good examples:**
```
feat(auth): add refresh token rotation

Tokens now rotate on each use to prevent replay attacks.
Previous tokens are immediately invalidated after refresh.

Closes #87
```

```
fix(jobs): prevent duplicate email sends on retry

Sidekiq retries were sending multiple welcome emails when
the SMTP connection timed out. Added idempotency key via
Redis to ensure each user receives exactly one email.

Fixes #142
```

**Bad examples:**
```
fix stuff          ← meaningless
WIP                ← never commit WIP to a PR
updated files      ← describes nothing
```

## Steps

1. Run `git diff --staged` — check what's actually being committed
2. If nothing is staged, run `git status` and ask what to include
3. Check the diff for:
   - Accidental debug code (`console.log`, `binding.pry`, `dd()`)
   - Hardcoded secrets or credentials
   - Commented-out code that shouldn't be committed
   - Files that shouldn't be in this commit
4. Draft the commit message following the format above
5. Show the message and confirm before committing
6. Run `git commit -m "..."`

## Rules

- Never commit secrets, credentials, or `.env` files
- Never commit `TODO` comments without an issue reference
- Never use `--no-verify` to skip hooks
- Keep commits atomic — one logical change per commit
- If you're committing more than 5 files with unrelated changes, split the commit
