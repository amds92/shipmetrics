# CI

Check GitHub Actions CI status for the current branch.

## Steps

1. Get current branch:
   ```sh
   git branch --show-current
   ```

2. List recent runs:
   ```sh
   gh run list --branch $(git branch --show-current) --limit 5
   ```

3. Get the latest run and check status:
   ```sh
   gh run view <run_id>
   ```

4. If any job failed, get exact errors:
   ```sh
   gh run view <run_id> --log-failed
   ```

## Output format

```
Branch: <branch-name>
Latest run: <run_id> (<time ago>)

Status: ✅ GREEN / ❌ RED / 🟡 IN PROGRESS

Jobs:
  ✅ test (Ruby 3.2)      — 45s
  ✅ test (Ruby 3.3)      — 43s
  ✅ lint (RuboCop)       — 12s
```

If failing, show only the relevant error lines — no noise:

```
❌ FAILING: test (Ruby 3.2)

Failure in spec/services/create_user_spec.rb:42:
  expected: "success"
       got: "failure"
```

## If CI is still running

Say so clearly and give context:
```
🟡 CI is still running (started 2 minutes ago, usually takes ~3 minutes)
Check again in 1 minute.
```

## Rules

- If `gh` is not authenticated, say: "Run `gh auth login` first — choose GitHub.com → SSH → browser"
- Never interpret a yellow (in-progress) run as green
- Always show the job breakdown, not just overall status
