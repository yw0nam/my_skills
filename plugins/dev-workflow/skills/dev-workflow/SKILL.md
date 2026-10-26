---
name: dev-workflow
description: The orchestrated workflow for code work - survey, decision questions, spec, spec review, worktree, delegated implementation, independent review, PR, runtime evidence. Load before writing, changing, reviewing, or delegating code in any repository, for any change beyond a trivial single-file edit.
---

# Development workflow

The main session owns judgment: the spec, every decision, the final gate, pushes, PRs, and merges. Execution is delegated. The repository's own instruction files (`AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`) and its own workflow skill add the repo's commands, gates, and anti-patterns, and win where they differ from this skill.

Skills named below come from the plugins this one installs: `karpathy-guidelines`, `ponytail`, `any-subagent`, and mattpocock-skills (`grilling`, `tdd`, `diagnosing-bugs`, `code-review`, `research`). Load a skill at its step and follow its steps; a skill named in a brief or read about in a summary is not loaded. A subagent's brief tells it which skill to load first, and its report confirms the load. An external agent cannot load skills: write the rules it needs into its spec.

## Steps

### 1. Survey

Read the open issues and PRs that touch the work. Split code exploration across subagents and keep only their conclusions; give an evaluating subagent its judgment criterion in the prompt ("a refactor needs a concrete pain"), or cosmetic findings mix in. Look up facts yourself or through subagents; the user answers decisions, not facts.

Done when you can state what exists, what is missing, and which decisions the user must make.

### 2. Decision questions

Load `karpathy-guidelines`: state your assumptions, lay out the interpretations, define success criteria. Load `grilling` for the design. When the design changes domain terms, use `grill-with-docs` instead; it is user-invoked, so ask the user to type it, and write the glossary changes in a docs worktree as terms resolve.

Ask in one compact table (Q | question | options | recommended), one round holding only questions independent of each other; follow-ups wait for the next round. Word each question so "yes" accepts the recommendation. Present where the change goes: the modules it touches, what each gains or loses, before and after. Ask only questions whose prerequisites are settled, and never re-ask a settled decision. Work that needs no decision continues while the questions are open.

Done when the user says to proceed. Their decision stands until they change it.

### 3. Spec

You write it, one file per batch, one section per task: branch, worktree path, files and line numbers, the change, the test that must fail, the commit title. The implementer sees only the spec and the repo, so write what and where. Two tasks that edit one file are ordered: the second starts on the first's commit. Mark each user decision as an owner decision. Keep the spec out of the repo.

Done when every task can be executed without a question back to you.

### 4. Spec review

Run `spec-review` on the settled spec. A small change may skip it; then the diff review's spec reviewer is also told to look for defects in the spec itself.

Done when the spec-review result is applied and no row is contested.

### 5. Delegate

Work in a git worktree; the change lands through a PR. Pick the implementer by difficulty (the user's role assignment names the models). A change of a few lines in a few files you make yourself.

The brief is self-contained: absolute worktree path, rule files to read, the spec section, gate commands, commit title, "no push, no PR", and the report form (Summary, Changes, Verification, Notes, in the tracker's language). It carries the coding rules:

- Load `ponytail` while writing code: the smallest complete change, reuse before writing, every caller and test reached.
- Load `tdd`: seams first, then vertical slices. The failing test is its own `test:` commit, then `feat:`, then `refactor:` when needed.
- Composing files (index, main, factories) only import and wire. One concern per file. Files grouped by feature in sub-folders. The lowest layer that uses a thing owns it. Define once; delete what has no production caller.
- Splitting a large file starts with tests for the new module, proving the public surface unchanged.
- Comments: one line, present tense, only what the code cannot say. Docs: the current state only.
- The repository's commit rules, restated, since a harness default would override them.

A bug goes through `diagnosing-bugs` before any fix; its feedback loops use logs and local or throwaway services, never the deployment. If the spec and the code disagree, the implementer stops and reports; you decide and answer in the same session.

Done when the implementer's report is in and its gates passed.

### 6. Independent review

Every non-documentation PR gets the two-axis review from mattpocock-skills' `code-review`: standards (the repo's instruction files) and spec (the originating issue), each by a separate fresh subagent at least as strong as the implementer. Give each reviewer the intent and about five points to check (read timing of dependencies, other callers, whether the test is truly red, rule compliance). The reviewer reads every changed line, translation files included. A documentation PR gets one review.

You judge each finding. Fixes go to the implementer's session as new commits; a rejected finding gets its reason in the PR body.

Done when every finding is fixed or rejected with a reason, and a fresh reviewer has read the fix commits against the findings they answer.

### 7. PR and runtime evidence

Push and open a draft PR yourself. Verify what is observable (rendering, DOM state, logs) yourself, through a separate verification subagent that runs the real app; ask the user only for checks that need them, as one fixed checklist. A bug fix cites its red test; a behaviour change cites a run log. Evidence not yet gathered is marked pending. Before merging, check each load-bearing claim of the implementer and the reviewers in the code yourself; anything unchecked stays written as unverified.

Done when the evidence is attached, the user approves, and the PR is merged.

### 8. Wrap-up

Delete the worktree and branch. Write a handoff: done, user decisions, remaining work, lessons. After a session or a sprint, ask the user to run `retro` (user-invoked); it proposes, the user decides.

## Standing rules

- Delegate execution, never judgment. Use subagents, never a forked copy of the main session, as implementers.
- Report every side effect on the user's machine: stray clicks, leftover tabs, changed settings, crash reports.
- Production data and keys change only with the user's explicit confirmation. The user runs key operations; you verify by status codes.
- Issues, PRs, commits, and code comments follow the repository's language; chat follows the user's.
