# Ship

Full readiness gate before merging to main. Nothing broken ever lands on main.

## The contract

This command guarantees:
1. Code has been reviewed by a senior engineer (Claude)
2. All tests pass on CI
3. No linter errors
4. The merge is clean and the branch is deleted after

If any gate fails — it stops. It tells you exactly what to fix.

## Steps

### Gate 1: Code Review
Run the full `/review` flow:
- Read all changed files
- Check architecture, quality, tests, security, performance
- **If CRITICAL issues found:** list them, abort, do not continue

### Gate 2: CI Status
Run the full `/ci` flow:
- Check GitHub Actions for the current branch
- **If CI is red or in progress:** show status, abort, do not continue
- **If no CI runs exist:** warn and ask for confirmation before proceeding

### Gate 3: Merge
If both gates pass:

```sh
BRANCH=$(git branch --show-current)

git checkout main
git pull origin main
git merge --no-ff $BRANCH -m "Merge branch '$BRANCH'"
git push origin main
git push origin --delete $BRANCH
git branch -d $BRANCH
```

Confirm with:
```sh
git log --oneline -3
```

## Output format

```
=== REVIEW ===
✅ No critical issues found
[or list of issues if any]

=== CI ===
✅ All jobs green
[or status if failing]

=== RESULT ===
✅ Merged 'feat/user-pagination' → main
✅ Branch deleted (remote + local)
Commit: abc1234 feat(users): add cursor-based pagination
```

Or if blocked:

```
=== RESULT ===
❌ Aborted — [reason: CRITICAL issues in review / CI is red / CI still running]
Fix the issues above and run /ship again.
```

## Rules

- Never merge if CI is red
- Never merge if there are CRITICAL review issues
- Always use `--no-ff` — preserve branch history in main
- Always delete the branch after merge (remote + local)
- Never force push to main — ever
