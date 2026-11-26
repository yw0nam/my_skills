# Issue tracker: GitLab

Issues for this repo live as GitLab issues. Use the `glab` CLI for all operations; run inside a clone, it infers the project from `git remote -v`.

## Conventions

- Create an issue: `glab issue create --title "..." --description "..."`, with a heredoc for multi-line descriptions. Open every issue from the matching template in `.gitlab/issue_templates/` (bug, feature_task, spike, decision); the template's `/label` line applies the label.
- Read an issue: `glab issue view <number> --comments`. Use `--output json` for machine-readable output.
- List issues: `glab issue list --output json`, with `--label` and `--closed` filters.
- Comment on an issue: `glab issue note <number> --message "..."`. GitLab calls comments notes.
- Apply or remove labels: `glab issue update <number> --label "..."` / `--unlabel "..."`.
- Close: `glab issue close <number>` takes no comment. Post the closing text first with `glab issue note`, then close.
- Merge requests: GitLab calls PRs merge requests (MRs). `gh pr create`, `gh pr view`, and `gh pr merge` map to `glab mr create`, `glab mr view`, and `glab mr merge`; `gh pr comment` maps to `glab mr note create`, and its `--body` flag maps to `--message`. Create an MR as a draft with `glab mr create --draft`.

GitLab numbers issues (`#n`) and MRs (`!n`) separately. Write `!n` for an MR and `#n` for an issue.

## Child issues and blocking

The project runs on the GitLab free plan, which has no native blocking links, epics, or weights.

- A child issue carries `Part of #<n>` on its own line at the top of its description. The parent lists its children in a task list.
- A blocked issue carries `Blocked by: #<n>, #<n>` on its own line at the top of its description. An issue is unblocked when every issue in its `Blocked by` line is closed.
- `Closes #<n>` in an MR description closes that issue when the MR merges into the default branch.

## Decision issues

A decision is a closed issue labeled `decision`, and its closing note holds the decision.

- Open it from the decision template with the context and the options.
- Close it: post a note with a `## Decision` section and a `## Consequences` section, `glab issue note <number> --message "..."`, then `glab issue close <number>`.
- List decisions: `glab issue list --label decision --closed`. Read one with `glab issue view <number> --comments`; the closing note is the last note.
- A later decision that replaces an earlier one is a new decision issue that names the one it replaces.

## Claim discipline (evidence-gated claims)

Issue and MR bodies carry two kinds of claims, and each has an evidence gate. An unverified claim is grounds for immediate rejection of the issue or MR.

- Prevention claims ("this refactor stops X-class bugs", "catches future bugs early") are admissible only with a measured RED: a failing test committed or linked, a reproduced defect, or a per-bug table over the cited past incidents showing the change would have gated each one. Without a RED, state the counted structural fact instead ("X is decided in N places").
- Quantitative claims (line counts, edit-site counts, blast radius, "N modules to add one value") are measured, with the measurement named: `wc -l`, `git show --name-only <commit>`, a grep count. A number without its measurement is rejected.
- Outcome promises ("bug class Y stops recurring") stay out of issue bodies and MR descriptions. Promise mechanisms and deletions verifiable at MR time.

## Merge requests as a triage surface

**MRs as a request surface: no.** _(Set to `yes` if this repo treats external merge requests as feature requests; `/triage` reads this flag.)_

When set to `yes`, MRs run through the same labels and states as issues, using the `glab mr` equivalents:

- Read an MR: `glab mr view <number> --comments` and `glab mr diff <number>` for the diff.
- List external MRs for triage: `glab mr list --output json`, then keep only MRs whose author is not a project member or owner (a contributor's MR, not a maintainer's in-flight work).
- Comment, label, close: `glab mr note create <number> --message "..."`, `glab mr update --label` / `--unlabel`, `glab mr close`.

## When a skill says "publish to the issue tracker"

Create a GitLab issue.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <number> --comments`.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a single issue with **child** issues as tickets.

- **Map**: a single issue labelled `wayfinder:map`, holding the Notes / Decisions-so-far / Fog body. `glab issue create --label wayfinder:map`.
- **Child ticket**: an issue carrying `Part of #<map>` at the top of its description and labels `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`). Once claimed, the ticket is assigned to the driving dev.
- **Blocking**: the free plan has no native blocking link, so a `Blocked by: #<n>, #<n>` line at the top of the child's description records it. A ticket is unblocked when every blocker is closed.
- **Frontier query**: `glab issue list --output json` scoped to the map's children. Drop any with an open issue named in its `Blocked by` line, or with an assignee; the first in map order wins.
- **Claim**: `glab issue update <n> --assignee <your username>`, the session's first write. The username comes from `glab auth status`.
- **Resolve**: `glab issue note <n> --message "<answer>"`, then `glab issue close <n>`, then append a context pointer (gist + link) to the map's Decisions-so-far.
