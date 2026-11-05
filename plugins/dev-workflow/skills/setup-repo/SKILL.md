---
name: setup-repo
description: Set up a repository with the engineering principles, testing rules, tracker conventions, and GitHub templates that dev-workflow reads - AGENTS.md, CLAUDE.md, CONTRIBUTING.md, docs/agent-guide/testing.md, docs/agents/issue-tracker.md, .github templates, and optional CI gates. Use when the user asks to set up, bootstrap, or onboard a repository, or runs setup-repo.
---

# Set up a repository

Write the instruction files and GitHub templates that carry the user's engineering principles into the current repository. The seed files are in `templates/` beside this file. Every other path below is in the target repository.

This is a prompt-driven skill: explore, ask, show the final drafts, wait for confirmation, then write.

## Files

| Template | Target | When |
|---|---|---|
| `templates/AGENTS.md.tmpl` | `AGENTS.md` | always |
| `templates/CLAUDE.md.tmpl` | `CLAUDE.md` | always |
| `templates/CONTRIBUTING.md` | `CONTRIBUTING.md` | always |
| `templates/docs/agent-guide/testing.md` | `docs/agent-guide/testing.md` | always |
| `templates/docs/agents/issue-tracker.md` | `docs/agents/issue-tracker.md` | always |
| `templates/github/PULL_REQUEST_TEMPLATE.md` | `.github/PULL_REQUEST_TEMPLATE.md` | always |
| `templates/github/ISSUE_TEMPLATE/*.yml` | `.github/ISSUE_TEMPLATE/*.yml` | always |
| `templates/github/workflows/pr-title.yml` | `.github/workflows/pr-title.yml` | the user picks the `pr-title` gate |
| `templates/github/workflows/test-guard.yml`, `templates/scripts/ci/test-guard.sh` | `.github/workflows/test-guard.yml`, `scripts/ci/test-guard.sh` (mode `755`) | the user picks the `test-guard` gate |

A `{{fill: ...}}` marker names what to put in its place. A `{{variant: ...}}` ... `{{/variant}}` block is kept or deleted whole, by the user's answer; a gate's variant stays only when the user picks that gate. A fill with no value is deleted; a fill that fills its whole line is deleted with the line. Deleting a block leaves no doubled blank line. No marker survives into a written file.

## Steps

### 1. Explore

Read what exists. Assume nothing.

- `git remote -v`: the GitHub `<owner>/<repo>` for template links and `gh` commands.
- `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, `docs/`, `.github/`: what each already says.
- `GLOSSARY.md` or another glossary file, and its layout.
- Languages, the test runner, and the build, test, and lint commands that CI or the manifest runs.
- The top-level package or folder layout, and whether it has a layer order.
- The contracts other code or other people depend on: a schema, an API, config keys, a wire format.
- Tags and releases (`git tag`, `gh release list`).
- Labels (`gh label list`).

Done when every fill marker has a value from the survey or a question for the user.

### 2. Ask

Ask in one table (Q | question | options | recommended). Always ask the first three; add a row for each fill marker the survey could not settle.

1. Who uses this repository? Only the user: an old path is deleted outright, released or not. Other people too: a path no release shipped is deleted outright, and a released one goes through a deprecation period. `main` moves; releases are the stable surface.
2. Add the `pr-title` CI gate? It checks the conventional-commit type, an ASCII subject, and an AI attribution line in the PR body.
3. Add the `test-guard` CI gate? It fails a PR that adds more than 20 source lines and changes no test file. The `skip-tests` label bypasses it.

Done when the user answers.

### 3. Show the drafts

For each target, show the final text: the template with every marker filled and the variant chosen. For a file that exists, show the merged result. A section the template and the file both have keeps the file's repo-specific lines and gains the template's rules. A section only the file has stays. When the file and the template state opposite rules, ask which one stands.

- An issue template in Markdown (`.github/ISSUE_TEMPLATE/bug.md`) that shares a name with a form template is merged into the `.yml` form and deleted, so the chooser lists each kind once.
- `CLAUDE.md`'s `### Domain docs` block stays only when a glossary exists, and points at the real file.
- A worktree path inside the repository gains its folder in `.gitignore`.

Done when the user confirms the drafts. Their edits go into what you write.

### 4. Write

Write the confirmed drafts. Then:

- Give `scripts/ci/test-guard.sh` mode `755`.
- Check the result: `grep -rnE '\{\{(fill|variant|/variant)' AGENTS.md CLAUDE.md CONTRIBUTING.md docs .github scripts` prints nothing, every written `.yml` parses, and `bash -n scripts/ci/test-guard.sh` passes when the gate was added.
- List each label the templates name that `gh label list` lacks (`bug`, `feature`, `spike`, `decision`, `breaking`, plus `skip-tests` with the `test-guard` gate), with the `gh label create <name>` command for each. When `gh` cannot reach the repository, list them all. Creating labels changes the GitHub repository, so run the commands only when the user says to.
- When a CI gate was added, tell the user to mark its check as required in the branch protection rules of `main`.

Done when the files are written and the user has the label and branch protection steps.

### 5. Report

List the files written and merged, the questions answered, and the steps left to the user.
