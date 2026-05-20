# Branch

Create a correctly named Git branch for the current task.

## Branch naming convention

```
<type>/<short-description>
```

**Types:**
| Type | When to use |
|------|------------|
| `feat/` | New functionality |
| `fix/` | Bug fix |
| `chore/` | Maintenance, dependencies, config, tooling |
| `refactor/` | Code improvement without behaviour change |
| `docs/` | Documentation only |
| `test/` | Adding or fixing tests only |
| `perf/` | Performance improvements |

**Description rules:**
- Lowercase, hyphen-separated
- Max 40 characters
- Descriptive but concise
- No ticket numbers in the branch name (those go in the commit)

**Examples:**
```
feat/user-pagination
fix/token-expiry-calculation
chore/upgrade-rails-8
refactor/extract-payment-service
docs/api-authentication-guide
perf/n-plus-one-users-query
```

## Steps

1. Confirm there is a current task context (from `/task`). If not, ask what the task is.
2. Derive the branch name from the task description.
3. Show the proposed branch name and confirm before creating.
4. Run:
   ```sh
   git checkout main
   git pull origin main
   git checkout -b <branch-name>
   ```
5. Confirm the branch was created: `git branch --show-current`

## Rules

- Always branch from an up-to-date `main`
- Never work directly on `main`
- One branch = one concern. If a task grows into multiple concerns, split into multiple PRs.
