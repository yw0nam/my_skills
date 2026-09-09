# my_skills

Personal skill repository. One repo serves as both a Claude Code marketplace and a Codex
marketplace. Both CLIs read the same `skills/<name>/SKILL.md` layout, so a skill body lives here
once.

## Install

Claude Code:

```
/plugin marketplace add yw0nam/my_skills
/plugin install design-doc-rules@yw0nam-skills
```

Codex:

```
codex plugin marketplace add yw0nam/my_skills
codex plugin add design-doc-rules@yw0nam-skills
```

To update: `/plugin update` in Claude Code; `codex plugin marketplace upgrade` followed by
`codex plugin add` in Codex.

## Plugins

| Name | What it does |
|---|---|
| `design-doc-rules` | Five sections of rules and a grep-based checker, `check.sh`, that strip machine-flavoured prose from design documents, proposals, technical docs, and slide decks in Korean or English |

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
2. Copy the two manifests from `plugins/design-doc-rules` and edit the values. `version` in the Codex
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
