# PR

Create a pull request with a description that actually communicates what was done and why.

## What makes a great PR

From 37signals: "PRs are how coding standards transmit to new team members." A lazy PR description is a missed opportunity to teach, share context, and make the reviewer's job easier.

From GitHub's data: the best PRs are small and single-purpose. If your PR does 3 things, split it into 3 PRs.

## Steps

### 1. Pre-flight checks
Before creating the PR:
```sh
git status                    # no uncommitted changes
git diff main...HEAD --stat   # confirm what's in the PR
```

Run the linter:
```sh
# Ruby
bundle exec rubocop

# Python
ruff check .

# JavaScript/TypeScript
npm run lint

# PHP
./vendor/bin/phpcs
```

If linter fails → fix before creating PR. Never open a PR with linter errors.

### 2. Run tests
```sh
# Ruby
bundle exec rspec

# Python
pytest

# JavaScript
npm test

# PHP
./vendor/bin/phpunit
```

If tests fail → fix before creating PR. Never open a PR with failing tests.

### 3. Generate the PR description

Read `git log main...HEAD` and `git diff main...HEAD` to understand the full change.

Write the description using this structure:

```markdown
## What
[What does this PR do? One clear paragraph.]

## Why
[Why is this needed? What problem does it solve?]
Closes #[issue]

## How
[How was it implemented? Mention non-obvious decisions or trade-offs.]

## Testing
[How to test manually:]
1. [Step]
2. [Step]
3. [Expected result]

## Checklist
- [ ] Tests added/updated
- [ ] No linter warnings
- [ ] CHANGELOG updated (if user-facing)
```

### 4. Create the PR
```sh
gh pr create \
  --title "[type]: [description]" \
  --body "$(cat <<'EOF'
[the description above]
EOF
)"
```

### 5. Output
Show the PR URL for review.

## Rules

- PR title follows Conventional Commits: `feat:`, `fix:`, `chore:`, etc.
- Never open a PR from main
- Never open a PR with failing tests or linter errors
- If the PR is large (>400 lines changed), mention it and suggest splitting
- Draft PRs are fine for work-in-progress — use `--draft` flag
