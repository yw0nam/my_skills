---
name: spec-review
description: Review a settled implementation spec for over-engineering before any code is written. A fresh reviewer asks of every item - is it YAGNI, does it pay for the code it adds, is there a simpler path - and the author answers from the code. Use after the spec is settled and before implementation is delegated.
---

# Spec review

A spec is the file-level plan for a change: what it adds, which files it edits, which tests it writes. Run this after the spec is settled and before the first edit.

The reviewer is a fresh agent with none of this conversation: the one the user's role assignment names for spec review or spec consultation. Ask the user only when the assignment names none. You are the author. The user decides what stays contested.

## Depth

Pick the depth from the change before step 1. The first row that matches wins.

| Depth | The change | Steps |
|---|---|---|
| Full | changes a contract, a wire format, persisted data, or a released config key; adds a module; or a revert cannot undo it | 1 to 5 |
| Light | adds a file, a public symbol, or a config key, and a revert undoes it | 1 to 3, then 5 with no step 4: a rebutted row goes to the user as contested, with your evidence |
| Skip | stays inside one existing module and adds no file, public symbol, or config key | none; tell the diff review's spec reviewer to look for defects in the spec as well |

## Steps

### 1. Number the spec

Give every item an ID (`S1`, `S2`, ...). An item is one new file, one edited file, one new symbol, one config key, one test, or one behaviour. Split a line that holds two.

Done when every item has an ID and holds one thing.

### 2. Send it to the reviewer

Send the reviewer exactly four things:

- the numbered spec,
- the originating requirement (the issue body, or the user's own words),
- the decisions the user already settled for this spec, one line each, as statements without their rationale,
- the full text of [`REVIEWER.md`](REVIEWER.md).

Keep your reasoning and the alternatives you rejected out of the message. The reviewer finds its own alternatives in the code.

The reviewer works in the worktree the spec targets, before its first edit, with dependencies installed. It runs tests, builds, and scripts there, opens a library's types and docs to check a claim about its API, and leaves `git status` clean when it reports.

A subagent's completion notice can cut its result short. When the result stops mid-table, ask the reviewer for the rest before you go on.

Done when the reviewer returns its verdict, its findings, and its cut list.

### 3. Answer every finding

For each finding, either **accept** it and change the spec, or **rebut** it.

A rebuttal stands on evidence you looked up while answering: a `file:line` that shows the need, a quoted requirement line that nothing simpler serves, or a measured RED. Open the code the finding names before you answer it. "Future flexibility", "best practice", "only a few lines", and "consistency" without a cited `file:line` are reasons to accept.

Done when every finding is accepted or rebutted with evidence.

### 4. One rebuttal round

Send the reviewer your rebuttals only. It answers each with **drop** or **hold**, and one line of reason. Stop after this round.

Done when every rebutted finding is dropped or held.

### 5. Hand the result to the user

Show one table:

| ID | Finding | Answer | Evidence | Status |
|---|---|---|---|---|

Status is **cut**, **changed**, **kept**, or **contested** (held after rebuttal). A row marked `reverses decision` goes to the user like a contested row, even when you accepted it: the decision was theirs. Ask the user to decide each of these rows, then rewrite the spec with every decision applied and list what was removed.

Done when no row is contested and the revised spec is written.

## Reading the result

- You accepted nothing: re-read your two weakest rebuttals. Reflex defence looks like a rebuttal with no `file:line`.
- The reviewer proposed more machinery than the spec had (a parser, a library, a new layer): that is a different design, not a simplification. Weigh it as one, by the same ROI question.
- A finding cut trust-boundary validation, data-loss handling, security, or a place the change must reach: restore it.
