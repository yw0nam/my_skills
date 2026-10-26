# my_skills

Personal skill repository and the one place that installs every skill and plugin I use. The repo
is a Claude Code marketplace and a Codex marketplace for its own plugins, and its install list
pulls the rest from their upstream repos.

## Install

Agents: when asked to install this repo, run every command below for each CLI that exists on the
machine (`command -v claude`, `command -v codex`, `command -v opencode`, `command -v pi`). A
`marketplace add` that reports the marketplace already exists is fine; continue with the next
command. Report each command that failed.

| Skill or plugin | Upstream | Claude Code | Codex | OpenCode, Pi |
|---|---|---|---|---|
| `dev-workflow` | this repo | plugin, installs the rows marked "dependency" | plugin | `npx skills` |
| `ponytail` | [dietrichgebert/ponytail](https://github.com/dietrichgebert/ponytail) | dependency | plugin | `npx skills` |
| `any-subagent` | [yw0nam/any-subagent](https://github.com/yw0nam/any-subagent) | dependency | not installed; it drives Codex from Claude Code | not installed |
| `mattpocock-skills` | [mattpocock/skills](https://github.com/mattpocock/skills) | dependency | `npx skills` | `npx skills` |
| `karpathy-guidelines` | [multica-ai/andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills) | dependency | `npx skills` | `npx skills` |

Each row follows the install method its upstream README documents. Plugins keep their hooks and
bundled binaries; repos that ship only `SKILL.md` go through [skills](https://github.com/vercel-labs/skills).

Claude Code. A dependency installs only from a marketplace that is already added, so the four
`marketplace add` lines run before `plugin install`:

```bash
claude plugin marketplace add DietrichGebert/ponytail
claude plugin marketplace add multica-ai/andrej-karpathy-skills
claude plugin marketplace add yw0nam/any-subagent
claude plugin marketplace add yw0nam/my_skills
claude plugin install dev-workflow@yw0nam-skills
```

Codex:

```bash
codex plugin marketplace add yw0nam/my_skills
codex plugin add dev-workflow@yw0nam-skills
codex plugin marketplace add DietrichGebert/ponytail
codex plugin add ponytail@ponytail
npx -y skills add multica-ai/andrej-karpathy-skills --skill karpathy-guidelines -g -a codex -y
npx -y skills add mattpocock/skills -g -a codex -y --skill \
  ask-matt diagnosing-bugs grill-with-docs triage improve-codebase-architecture \
  setup-matt-pocock-skills tdd to-spec to-tickets wayfinder implement prototype research \
  domain-modeling codebase-design code-review resolving-merge-conflicts wizard grill-me grilling \
  handoff teach to-questionnaire wait-what writing-for-agents
```

OpenCode and Pi read `SKILL.md` but have no plugin dependencies, so each skill installs on its own:

```bash
npx -y skills add yw0nam/my_skills -g -a opencode -a pi -y --skill dev-workflow spec-review
npx -y skills add DietrichGebert/ponytail --skill ponytail -g -a opencode -a pi -y
npx -y skills add multica-ai/andrej-karpathy-skills --skill karpathy-guidelines -g -a opencode -a pi -y
npx -y skills add mattpocock/skills -g -a opencode -a pi -y --skill \
  grilling tdd diagnosing-bugs code-review research writing-for-agents
```

The `mattpocock/skills` list matches the skills its Claude Code plugin ships; the repo's
`in-progress` and `misc` skills stay out. Ponytail's hooks need `node` on `PATH`, and Codex asks
you to trust them once under `/hooks`.

After install, restart the CLI. To update: `claude plugin marketplace update` then
`claude plugin update <plugin>`; `codex plugin marketplace upgrade` then `codex plugin add`;
`npx skills update -g` for the `npx skills` rows.

## Plugins

| Name | What it does |
|---|---|
| `dev-workflow` | Two skills: `dev-workflow`, the orchestrated workflow for code work from survey to merge, and `spec-review`, a gate where a fresh reviewer asks of every spec item whether it is YAGNI, whether it pays for its code, and whether a simpler path exists. Installing it on Claude Code installs the skills the workflow names |
## Layout

```
.claude-plugin/marketplace.json     Claude Code marketplace catalog
.agents/plugins/marketplace.json    Codex marketplace catalog
plugins/<name>/
  .claude-plugin/plugin.json        Claude Code manifest
  .codex-plugin/plugin.json         Codex manifest, requires an `interface` block
  skills/<skill>/SKILL.md           skill body, shared by both CLIs
```

## Adding a skill

1. Write `plugins/<name>/skills/<skill>/SKILL.md`. The frontmatter holds two fields, `name` and
   `description`.
2. Copy the two manifests from `plugins/dev-workflow` and edit the values. `version` in the Codex
   manifest takes strict semver, and `interface` takes `displayName`, `shortDescription`,
   `longDescription`, `developerName`, `category`, `capabilities`, and `defaultPrompt`.
3. Add an entry to both marketplace catalogs.
4. Validate:

```
claude plugin validate plugins/<name> --strict
claude plugin validate . --strict
python3 ~/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<name>
```

A skill that ships a script says in its `SKILL.md` to run the script from the skill directory. The
two CLIs unpack a plugin under different cache paths, so a hardcoded absolute path breaks.

Conventions for working in this repo are in [AGENTS.md](AGENTS.md).
