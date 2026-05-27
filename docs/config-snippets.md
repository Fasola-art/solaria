# Config Snippets

These are minimal snippets for wiring the shared skill system into local Claude/Codex configuration. They are intentionally not full user config files.

The recommended path is to run the installer first:

```sh
./install.sh --dry-run
./install.sh
```

Use the snippets below only when wiring runtimes manually.

## Claude

Add an import to `~/.claude/CLAUDE.md`:

```md
@rules/skill-management.md
```

Create `~/.claude/rules/skill-management.md` with instructions equivalent to `skills/skill-management/SKILL.md`.

Recommended symlink:

```sh
ln -sfn ../../.agents/skills/skill-management ~/.claude/skills/skill-management
```

If using Claude hooks, wire:

```text
PreToolUse  -> ~/.agents/bin/skill-path-guard
PostToolUse -> ~/.agents/bin/skill-change-log
```

## Codex

Recommended symlink:

```sh
ln -sfn ../../.agents/skills/skill-management ~/.codex/skills/skill-management
```

Optional `~/.codex/config.toml` hook snippet:

```toml
[hooks]
PreToolUse = [{ command = "/Users/YOUR_USER/.agents/bin/skill-path-guard" }]
PostToolUse = [{ command = "/Users/YOUR_USER/.agents/bin/skill-change-log" }]
```

Validate config:

```sh
codex --strict-config doctor --summary --ascii
```

Current Codex limitation: live `codex exec` observation showed that `apply_patch` may bypass hook enforcement. Run `~/.agents/bin/skill-health-check --write` after Codex skill work.
