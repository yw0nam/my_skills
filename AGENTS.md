# AGENTS.md

Personal skill repository. One repo serves two CLIs: Claude Code reads
`.claude-plugin/marketplace.json`, Codex reads `.agents/plugins/marketplace.json`, and both read the
same `plugins/<plugin>/skills/<skill>/SKILL.md`. Layout and install commands are in
[README.md](README.md).

## Working principles

1. Before designing a solution, look at how established products solve the same problem. Adopt
   proven patterns and conventions.
2. Delete unused paths in place of adding compatibility layers, fallbacks, and migrations.
3. Choose the simplest implementation that fully meets the current requirement. Speculative
   abstractions, config values, and indirection layers stay out.
4. Grow the system in layers. Start from the smallest version that works end to end, then add one
   feature at a time on top of what already runs. Working code outranks unfinished complexity.
5. Split components into modules with separated concerns.
6. Use a maintained library when it lowers total complexity or raises stability. Reimplementing a
   common feature needs a stated reason.
7. Check the installed dependencies before writing an implementation or adding a package. Read the
   docs and types before concluding that a library lacks a feature.
8. Make architecture decisions for the long term. A stopgap that gets replaced later is rejected.

## Project rules

### Paths that stay as they are

1. The prose in a `SKILL.md` is hand-written. Fix typos and endings; a rewrite waits for a request.
2. Plugin and skill directory names are the install id (`design-doc-rules@yw0nam-skills`). A rename
   breaks every install in the field. Add a plugin in place of renaming one.
3. `~/.claude/skills/`, `~/.codex/skills/`, and `~/.codex/plugins/cache/` are install targets. Edits
   there vanish on the next install; sources live in this repo.
4. Every skill script keeps mode `755` in git. `git ls-files -s` shows `100755`; a `100644` script
   fails at the first call after install.

### Run before finishing

```bash
claude plugin validate . --strict                 # marketplace catalog
claude plugin validate plugins/<name> --strict    # Claude manifest
python3 ~/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<name>
```

The Codex validator rejects a manifest field outside its allowed set and requires strict semver in
`version`, an `author.name`, and the full `interface` block: `displayName`, `shortDescription`,
`longDescription`, `developerName`, `category`, `capabilities`, `defaultPrompt`.

Bump `version` in `.codex-plugin/plugin.json` and the `.claude-plugin/marketplace.json` entry
together on every change to a plugin. Codex unpacks into
`~/.codex/plugins/cache/<marketplace>/<plugin>/<version>/`, so a reused version number serves the
old copy.

### Security

1. Public repo. Scan a new `SKILL.md` or script for employer code, documents, API details, logs,
   credentials, and real data before committing. Cite public sources.
2. Skill scripts run on the user's machine under the user's permissions. A script reads local files,
   writes to the path passed as an argument, and stays offline.
