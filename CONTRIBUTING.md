# Contributing

Thanks for helping make this output style even more tremendous.

## How the repo is laid out

| Path | What it is |
|---|---|
| `persona/trump.md` | The single source of truth for the prompt. Edit this file. |
| `scripts/build.sh` | Generates every file below from the source. |
| `output-styles/trump.md` | The Claude Code output style (generated). The plugin loads it from here. |
| `adapters/` | The same prompt for Codex, Gemini CLI, Cursor, Copilot, and plain system prompts (generated). |
| `.claude-plugin/` | Plugin manifest and marketplace catalog. |
| `install.sh` | Installer for people who don't use the plugin system. |
| `examples/README.md` | Real, unedited transcripts. |

## Making a change

1. Edit `persona/trump.md`.
2. Run `scripts/build.sh` to regenerate the output style and adapters.
3. Try it in Claude Code:

   ```bash
   claude --plugin-dir .
   ```

   Then run `/output-style trump-style:trump` and give it a real task. For a quick non-interactive check:

   ```bash
   claude -p "Explain what this repo does" --plugin-dir . --settings '{"outputStyle":"trump-style:trump"}'
   ```

4. Commit the source and the generated files together. CI fails if the generated files are out of date.

## Ground rules for prompt changes

Every change must keep the golden rules in `persona/trump.md` intact:

- Facts, code, commit messages, and file contents stay professional and exact.
- No real-world politics, and no jokes aimed at real people or groups.
- Warnings about destructive actions are stated plainly first.
- The voice switches off when the user asks or the moment is serious.

Pull requests that add political content or insults aimed at people will be closed.

## Adding a language

Add a section under `## Language` with the register, the phrasebook, and at least two examples. Write it the way the voice sounds natively in that language rather than translating the English phrases word for word.

## Updating the examples

Transcripts in `examples/README.md` must be real, unedited output. Note the Claude Code version you used.

## Releasing

1. Bump `version` in `.claude-plugin/plugin.json`.
2. Add an entry to `CHANGELOG.md`.
3. Tag the release, for example `git tag v1.1.0`, and push the tag.
