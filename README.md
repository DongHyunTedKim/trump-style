# trump-style

**The best output style for Claude Code. Tremendous. Everybody says so.**

[![CI](https://github.com/DongHyunTedKim/trump-style/actions/workflows/ci.yml/badge.svg)](https://github.com/DongHyunTedKim/trump-style/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-d97757.svg)](#claude-code-plugin-recommended)

English | [한국어](README.ko.md)

> **한국어 사용자라면:** 프롬프트를 한국어로 작성한 한국어판 스타일 `trump-ko`가 있습니다. [한국어 README](README.ko.md)를 보세요.

trump-style gives Claude Code and other AI coding agents a Trump-style voice. Your agent still reads, reasons, edits, tests, and reports exactly as before. It just talks like it's at a rally.

> Fixed. Fixed beautifully. `node --test` now passes 3 out of 3 tests, 0 failures. A perfect score, believe me.
>
> | Location | Problem | Fix |
> |---|---|---|
> | `cart.js:5` | The **Off-by-One Overreacher**: `i <= items.length` ran one step past the end of the array, so `items[2]` was `undefined` and reading `.price` threw a `TypeError`. That crashed all 3 tests. Disaster! | Changed it to `i < items.length` |
> | `cart.js:9` | The **Shrinking Discount**: it subtracted the rate itself (`total - 0.1`), so SAVE10 gave `24.9` instead of `22.5`. Sad! | Changed it to `total * (1 - discounts[code])` |
>
> Let me tell you, the second bug only showed up after the first one was fixed. Very, very sneaky. I haven't committed anything. Just say the word and I'll do it. We made this test suite great again!

This is real, unedited Claude Code output from the English edition. The commit message, the code, and the test numbers in that same session were all normal. See [more transcripts](examples/README.md), including Korean, commit messages, a political question, and a production incident.

## Two editions

| Style | For | What it does |
|---|---|---|
| **`trump`** (English edition) | English speakers and mixed-language users | Replies in your language. Built around Trump's English rally style, with a Korean phrasebook included. |
| `trump-ko` (Korean edition) | Korean speakers | The prompt itself is written in Korean, and it always replies in Korean. It follows the "translated Trump speech" style that Korean internet memes made famous: very short sentences, shameless self-praise, comparisons with the old way of doing things, simple interjections like `SAD!`, and a closing "이 문제에 관심을 가져주셔서 감사합니다!" every time. See the [Korean transcripts](examples/README.ko.md). |

Both editions are tuned for confident persuasion as much as for laughs. Use them when you want to pitch an idea, lead a meeting, or present with total conviction. The joke is deadpan certainty, not slapstick.

## Install

### Claude Code plugin (recommended)

Run these inside Claude Code:

```text
/plugin marketplace add DongHyunTedKim/trump-style
/plugin install trump-style@trump-style
/output-style trump-style:trump
```

Or from your shell:

```bash
claude plugin marketplace add DongHyunTedKim/trump-style
claude plugin install trump-style@trump-style
```

Then run `/output-style trump-style:trump` in Claude Code, or open `/config` and pick it under **Output style**. For the Korean edition, pick `trump-style:trump-ko`. To get new versions, run `/plugin marketplace update trump-style`.

### One-line script

```bash
curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash
```

This copies both styles to `~/.claude/output-styles/`. Switch with `/output-style trump` or `/output-style trump-ko`. Add options after `bash` to change what it does: `-s -- --style trump` installs one edition only, `-s -- --project` installs for the current project only, and `-s -- --uninstall` removes them.

### Manual

Download [`output-styles/trump.md`](output-styles/trump.md) (or [`trump-ko.md`](output-styles/trump-ko.md) for the Korean edition) into `~/.claude/output-styles/` for every project, or into `.claude/output-styles/` for one project. Then run `/output-style trump`.

On Windows (PowerShell):

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude\output-styles" | Out-Null
Invoke-WebRequest https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/output-styles/trump.md -OutFile "$HOME\.claude\output-styles\trump.md"
```

### Make it your default

Set `outputStyle` in `~/.claude/settings.json`. The value is case-sensitive.

```json
{ "outputStyle": "trump-style:trump" }
```

Use `"trump"` instead if you installed with the script or by hand. For the Korean edition, use `"trump-style:trump-ko"` or `"trump-ko"`.

## Other AI agents

Each edition is generated for other tools from its single source. The Korean edition's files live in [`adapters/ko/`](adapters/ko/). Only Claude Code has been tested end to end. Results with other agents depend on their models.

| Agent | File | Where it goes |
|---|---|---|
| Codex CLI | [`adapters/AGENTS.md`](adapters/AGENTS.md) | Append to `~/.codex/AGENTS.md` |
| Gemini CLI | [`adapters/GEMINI.md`](adapters/GEMINI.md) | Append to `~/.gemini/GEMINI.md` |
| Cursor | [`adapters/cursor/trump-style.mdc`](adapters/cursor/trump-style.mdc) | Copy to `.cursor/rules/` |
| GitHub Copilot | [`adapters/copilot-instructions.md`](adapters/copilot-instructions.md) | Append to `.github/copilot-instructions.md` |
| OpenCode, Amp, and other `AGENTS.md` readers | [`adapters/AGENTS.md`](adapters/AGENTS.md) | Append to the agent's global `AGENTS.md` |
| Claude.ai, ChatGPT, API, Agent SDK | [`adapters/system-prompt.md`](adapters/system-prompt.md) | Paste into custom instructions, project instructions, or the system prompt |

Prefer your personal, global instruction file. A project-level `AGENTS.md` or rules file is shared with everyone who works in that repo, and your teammates might not want a rally in their terminal.

## What changes and what doesn't

| Changes | Stays exactly the same |
|---|---|
| The replies Claude writes to you in the conversation | Code, comments, commit messages, PR descriptions, and anything written to files |
| Superlatives, repetition, verdicts like "Sad!" and "Big win!" | Facts: numbers, paths, line numbers, test results, error messages |
| Nicknames for bugs, such as Crooked Cache and Low-Energy Loop | Claude Code's software engineering instructions (`keep-coding-instructions: true`) |
| Occasional "Thank you for your attention to this matter!" | Warnings about destructive or security-sensitive actions, which are stated plainly first |

## Built-in guardrails

- **Apolitical.** The parody is about speaking style only. Asked about real politics, Claude answers neutrally in its normal voice, then picks the persona back up for the code. [See the transcript.](examples/README.md#4-real-world-politics-the-persona-steps-aside)
- **Punches at bugs, not people.** Nicknames and "disaster" talk are aimed at bugs, flaky tests, and tech debt. They are never aimed at you, your teammates, or any real person or group.
- **Honest.** Failures, uncertainty, and Claude's own mistakes are reported plainly. Hyperbole goes into adjectives, never into data.
- **Knows when to stop.** Say "be serious" or "normal mode", or hit a production incident, and the voice turns off. [See the transcript.](examples/README.md#5-be-serious-the-persona-switches-off)

## Controls

| Say this | Effect |
|---|---|
| `lite` / `살살` | Quieter: one or two flourishes per reply |
| `full rally` / `풀파워` | Maximum voice, still within the guardrails |
| `stop`, `normal mode`, `be serious`, `진지하게` | Plain voice until you ask for it back |
| `/output-style default` | Turn the style off |

## Languages

The English edition replies in your language, and the voice adapts instead of translating word for word. It has dedicated English and Korean phrasebooks. For Korean, the dedicated `trump-ko` edition goes much further; see [Two editions](#two-editions).

## FAQ

**Will it make my code worse?**
No. The style keeps Claude Code's engineering instructions (`keep-coding-instructions: true`) and only changes conversational prose. In testing, the code changes and commit messages stayed plain and professional.

**What does it cost?**
The English edition adds about 14 KB of instructions to the system prompt, and the Korean edition about 19 KB. Prompt caching makes that cheap after the first request in a session. Replies are about as long as usual.

**Does it apply to subagents?**
No. Claude Code applies output styles to the main conversation and to forks only. Other subagents run their own system prompts.

**Why is the plugin version called `trump-style:trump`?**
Claude Code namespaces plugin components under the plugin name. The script and manual installs register them as plain `trump` and `trump-ko`.

**Can I tweak it?**
Yes. Copy `output-styles/trump.md` into `~/.claude/output-styles/`, change the `name` in its frontmatter, and edit freely. To contribute changes back, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Uninstall

- Plugin: `/plugin uninstall trump-style@trump-style`
- Script: `curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash -s -- --uninstall`
- Manual: delete `~/.claude/output-styles/trump.md` and `trump-ko.md`

If `outputStyle` in your settings still points to the style, run `/output-style default`.

## Disclaimer

This project is a parody of a public figure's widely known speaking style, made for entertainment. It is not affiliated with, endorsed by, or sponsored by Donald J. Trump, The Trump Organization, any political campaign or party, or Anthropic. It takes no political position, and the prompt instructs the model to stay out of politics.

## License

[MIT](LICENSE)
