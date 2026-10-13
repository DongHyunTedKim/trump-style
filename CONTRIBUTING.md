# Contributing

[한국어](CONTRIBUTING.ko.md)

Thanks for helping make this output style even more tremendous.

## How the repo is laid out

| Path | What it is |
|---|---|
| `persona/trump.md` | Source of the English edition (`trump`). Edit this file, not the generated ones. |
| `persona/trump-ko.md` | Source of the Korean edition (`trump-ko`), written in Korean. |
| `scripts/build.sh` | Generates every file below from the source. |
| `output-styles/` | The Claude Code output styles (generated). The plugin loads them from here. |
| `adapters/`, `adapters/ko/` | Each edition for Codex, Gemini CLI, Cursor, Copilot, and plain system prompts (generated). |
| `.claude-plugin/` | Plugin manifest and marketplace catalog. |
| `install.sh` | Installer for people who don't use the plugin system. |
| `examples/` | Real, unedited transcripts for each edition. |

## Making a change

1. Edit `persona/trump.md` or `persona/trump-ko.md`.
2. Run `scripts/build.sh` to regenerate the output style and adapters.
3. Try it in Claude Code:

   ```bash
   claude --plugin-dir .
   ```

   Then run `/output-style trump-style:trump` (or `trump-style:trump-ko`) and give it a real task. For a quick non-interactive check:

   ```bash
   claude -p "Explain what this repo does" --plugin-dir . --settings '{"outputStyle":"trump-style:trump"}'
   ```

4. Commit the source and the generated files together. CI fails if the generated files are out of date.

## Ground rules for prompt changes

Every change must keep the golden rules in both persona files intact:

- Facts, code, commit messages, and file contents stay professional and exact.
- No real-world politics, and no jokes aimed at real people or groups.
- Warnings about destructive actions are stated plainly first.
- The voice switches off when the user asks or the moment is serious.

Pull requests that add political content or insults aimed at people will be closed.

## Adding a language

Either add a section under `## Language` in `persona/trump.md`, or create a dedicated edition like `persona/trump-ko.md` and register it in `scripts/build.sh` and `install.sh`. Write it the way the voice sounds natively in that language rather than translating the English phrases word for word.

## Updating the examples

Transcripts in `examples/` must be real, unedited output. If you leave anything out, say so in the page. Note the Claude Code version you used.

## Releasing

1. Bump `version` in `.claude-plugin/plugin.json`.
2. Add an entry to `CHANGELOG.md` in both Korean and English.
3. Tag the release, for example `git tag v1.1.0`, and push the tag.
4. Write the GitHub release notes in both Korean and English.
