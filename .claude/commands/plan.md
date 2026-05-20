# Plan

Design the architecture before writing code. The most expensive bugs are architectural ones — they compound.

## When to use

Run `/plan` after `/task` and before writing any code, especially when:
- The task involves creating new files or classes
- Multiple services or components are involved
- You're unsure about the right pattern
- The task touches external services or integrations

## Steps

### 1. Read CLAUDE.md
Confirm the stack, patterns, and principles defined for this project.

### 2. Identify what needs to be built
For each piece of the task:
- Is this business logic? → Service object
- Is this slow or async? → Background job
- Is this scheduled? → Cron job
- Is this an external API call? → Client/Adapter
- Is this data transformation? → Plain Ruby/Python/JS object
- Is this HTTP handling? → Controller (thin)
- Is this shared behaviour? → Concern/Mixin/Decorator

### 3. Check for existing code
Before proposing anything new, search for:
- Similar services that already exist
- Utility methods that cover part of the task
- Patterns already established in the codebase

**Never create something that already exists in a different form.**

### 4. Define the structure

For each new file, state:
```
[filename] — [one-line purpose]
  - [method 1]: [what it does]
  - [method 2]: [what it does]
  Dependencies: [what it uses]
  Tests: [what will be tested]
```

### 5. Identify risks

- What could go wrong?
- What needs a feature flag?
- What needs a database migration?
- What breaks if this fails mid-execution?
- Is rollback possible?

### 6. Get confirmation

Present the plan and ask: "Does this look right before I start?"

Do not write production code until the plan is confirmed.

## Anti-patterns to catch

- Fat controllers — if a controller method is more than 10 lines, something is wrong
- Logic in models — models hold data structure, not workflows
- Inline external calls — API calls belong in clients, not in services or controllers
- Missing error handling — every integration point needs a failure path
- Missing tests — if it can't be tested, the design is probably wrong
