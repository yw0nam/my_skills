<!-- Title in English, conventional-commit format (becomes the squash-merge subject), with `!` for a breaking change. e.g. "feat: {{fill: an example title from this project}}" -->

## Summary
<!-- What and why. Lead with the smallest picture that shows the change: a call tree, a file tree, or a diff sketch. For every new constant, threshold, or special-cased status, add a line: why this value / branch and not the alternative. For a breaking change, name what was removed and what replaces it. -->

## Related issues
<!-- `Closes #N` or `Part of #N`, on its own line -->

## Related decisions
<!-- The decision issues this change implements or relies on: #N -->

## Runtime evidence
<!-- Unit tests are not runtime verification. For any behavioral change, paste
     {{fill: the evidence this project produces, e.g. a screenshot of the app window, the app-run log, an API response}}
     proving the behavior, before and after. Write "N/A: no runtime behavior
     change" only when the diff is non-runtime (docs, config, tooling). -->

## Merge danger
<!-- Door: one-way (hard to undo: {{fill: this project's one-way changes, e.g. a released config key, a stored setting, an API route, or the wire format changes; data is deleted}}) or two-way (a revert undoes it).
     Blast radius: what a defect breaks, in one line. -->

## Checklist
- [ ] New or changed behavior ships a test in this PR, committed failing first as its own `test:` commit{{variant: test-guard gate}} (or the `skip-tests` label justified){{/variant}}
- [ ] Runtime evidence attached above, or N/A justified
- [ ] No unverified assumptions: upstream docs and the running behavior checked first
- [ ] A breaking change carries `!` in the title and the `breaking` label
{{fill: one line per project-specific rule from CONTRIBUTING.md § Review checklist}}
