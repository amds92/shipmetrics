# Review

Perform a senior-level code review of all changes on the current branch. This is the gate before a PR is opened.

## What a senior engineer looks for

Not just "does it work" — but "is this the right solution, implemented correctly, that won't hurt us in 6 months."

## Steps

### 1. Get the diff
```sh
git diff main...HEAD
```
Read every changed file completely — not just the diff, but the surrounding context.

### 2. Check architecture

- **Separation of concerns** — is each class/function doing one thing?
- **Right abstraction** — is this a service, a job, a concern, a utility? Is it in the right place?
- **No business logic** in controllers, views, or templates
- **No duplication** — does similar code already exist elsewhere?
- **Correct pattern** — does this follow the patterns defined in CLAUDE.md?

### 3. Check code quality

- **Naming** — are variables, methods, and classes named clearly? Would a new team member understand?
- **Complexity** — is this more complex than it needs to be? Can it be simplified?
- **Magic values** — no hardcoded strings or numbers without explanation
- **Dead code** — no commented-out code, unused variables, unreachable branches
- **Error handling** — what happens when things fail? Are errors handled at the right level?

### 4. Check tests

- Every new public method or class has a test
- Tests cover the happy path AND failure cases
- No hardcoded external dependencies in unit tests (use doubles/mocks)
- Tests are readable — they document behaviour, not implementation
- No tests that test implementation details (test behaviour, not internals)

### 5. Check security

- No SQL injection risk (parameterized queries, ORM)
- No user input used unsanitized
- No secrets or credentials in code
- Authentication/authorization checked where needed
- No insecure direct object references

### 6. Check performance

- Any N+1 queries?
- Any synchronous operations that should be async?
- Any missing database indexes for new queries?
- Any large data operations that should be paginated or batched?

## Output format

```
=== CODE REVIEW ===

Branch: [branch name]
Files changed: [count]

--- CRITICAL (must fix before merge) ---
[List issues that will cause bugs, security problems, or major regressions]

--- CONCERN (should fix) ---
[List issues that are wrong but won't break immediately]

--- NITPICK (optional) ---
[Style improvements, naming suggestions, minor refactors]

--- VERDICT ---
[APPROVED / NEEDS CHANGES]
[One sentence summary]
```

## Rules

- Be specific — point to the exact file and line, not "the service has issues"
- Explain WHY something is wrong, not just that it's wrong
- Separate style from logic — linters handle style, you handle logic
- If something is good, say so — positive feedback is part of review culture
- Frame suggestions as questions when possible: "What do you think about naming this X?"
