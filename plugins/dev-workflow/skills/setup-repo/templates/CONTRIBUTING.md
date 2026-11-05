# Contributing to {{fill: project name}}

This is the single contributor guide. [`AGENTS.md`](AGENTS.md) carries the project orientation, the engineering principles and the on-demand docs index.

## Workflow

- All work lands through a PR from a worktree. `main` takes no direct commits. From the main checkout:

  ```bash
  git worktree add {{fill: worktree path, e.g. ../<repo>-<name> or worktree/<name> (gitignored)}} -b <branch> main
  ```

- New or changed behaviour ships its test in the same PR. Commit the failing test first as its own `test:` commit, then the implementation (`feat:` or `fix:`), then any `refactor:`. [`docs/agent-guide/testing.md`](docs/agent-guide/testing.md) holds the test rules.
- Write issues, issue comments, PR titles and PR bodies in English. Chat in any language.
- Verify observable behaviour yourself ({{fill: the evidence this project produces, e.g. a screenshot of the app window, the app-run log, an API response, pod logs}}) and paste the output in the PR's Runtime evidence section. Ask the user only for what requires them.

## Code rules

- Comments are one line, in the present tense, and state only what the code cannot say itself. A numeric constant's comment may name the measurement it came from. Decision history, spec citations and issue numbers belong in the issue and the PR body.
- Docs state the current system declaratively and match the code. Change narrative, PR or issue numbers as prose, dated changelogs and future or unbuilt work belong in the tracker.

## Breaking changes

The contracts are {{fill: what other code or other people depend on, e.g. the config keys under `configs/`, stored settings, the API, the wire format}}. `main` moves; releases are the stable surface.

{{variant: only the user uses the repository}}
A PR that drops or replaces a contract deletes the old path outright: no compat layer, fallback, warning or migration. The PR:

- marks its title with `!` (`feat!:`, `fix!:`) and carries the `breaking` label, which lists it under breaking changes in the release notes;
- names in its body what was removed and what replaces it;
- updates every doc that describes the path, in the same PR.
{{/variant}}

{{variant: other people use the repository}}
A contract that no release has shipped is deleted outright when a PR drops or replaces it: no compat layer, fallback, warning or migration. The PR:

- marks its title with `!` (`feat!:`, `fix!:`) and carries the `breaking` label;
- names in its body what was removed and what replaces it;
- updates every doc that describes the path, in the same PR.

A contract that a release shipped keeps working through a deprecation period. A PR that replaces it:

- keeps the old path working;
- logs a warning when a caller uses the old path;
- marks the old path deprecated and names its replacement in every doc that describes it;
- names the release that deletes the old path in a one-line comment at the old path and in the release notes.

The removal ships at least one release later, through a PR that follows the first list and deletes the comment and the warning.
{{/variant}}

Internal modules, names and file layout change freely.

## Review checklist

A review checks every diff against the rules in `AGENTS.md`, the rules above, and these traps:

- Value completeness. A diff that adds a field, a status, an event name or an enum value reaches every consumer of that value. A value one switch, allowlist or fallback leaves unhandled is a blocker.
- Outside input is untrusted. Input from users, the network or another process reaches the core only after a shape and vocabulary check. An unknown value takes a defined fallback.
- Races. Async, poll and teardown code is checked at the entry and the exit of every state: a poll that fires after shutdown, a waiter that never settles, a worker that writes after release.
- One source for the contract. Every consumer reads the one definition of a contract.
{{fill: one line per project-specific trap, e.g. "No hardcoding. Endpoints, models and paths come from `configs/`."}}

## Finding your way

To learn why code is the way it is, start with `git blame <file>`. When blame lands on a move or refactor commit, find where the token first appeared:

```bash
git log -S'<token>' --reverse
```

## Reporting issues

Open an issue with the matching template in `.github/ISSUE_TEMPLATE/`: bug, feature / task, spike or decision.

## Commits and PRs

- Use conventional commits: `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `perf:`, `test:`, `build:`, `ci:`, `chore:`, `revert:`. The PR title is the squash-merge subject and uses the same format.
- Fill the [PR template](.github/PULL_REQUEST_TEMPLATE.md): Summary (with a why-this-value line for every new constant, threshold or special-cased status), related issues, related decisions, Runtime evidence, Merge danger and the checklist.

## Before you open a PR

Run the checks CI runs:

```bash
{{fill: the build, test and lint commands, one per line}}
```
