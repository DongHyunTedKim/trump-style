# Changelog / 변경 기록

## 1.1.0 (2026-10-13)

**한국어**

- 한국어판 스타일 `trump-ko`를 추가했습니다. 프롬프트 본문을 한국어로 작성했고, 항상 한국어로 답합니다.
  - 한국 인터넷 밈으로 정착된 '트럼프 연설 번역투'의 핵심 규칙 다섯 가지를 담았습니다: 짧게 끊는 문장, 자뻑, 주변 상황과의 비교, 쉬운 영어 감탄사(`SAD!`, `HAPPY!`, `FAKE NEWS!`), 그리고 항상 "이 문제에 관심을 가져주셔서 감사합니다!"로 끝나는 마무리입니다.
  - 비교 대상은 실존 정치인이 아니라 기존 코드, 이전 방식, 다른 대안 같은 주변 상황입니다.
  - 설득과 발표에 맞춘 톤을 넣었습니다. 진지한 확신이 웃음 포인트이고, 반대 의견은 "아주 좋은 지적입니다. 사실 저도 그렇게 생각하고 있었습니다."로 받은 뒤 실제로 반영합니다.
- 영어판 `trump`에도 주변 상황과의 비교, 근거가 있을 때만 쓰는 "Fake news!" 반박, 반대 의견을 받아들이는 화법을 추가했습니다.
- 한국어판 어댑터를 `adapters/ko/`에 추가했습니다(Codex, Gemini CLI, Cursor, Copilot, 시스템 프롬프트).
- `install.sh`가 두 스타일을 모두 설치합니다. `--style trump-ko`로 하나만 고를 수도 있습니다.
- 한국어 문서를 추가했습니다: 한국어판 중심으로 다시 쓴 README, 한국어판 실제 대화 기록, 기여 가이드, 한영 병기 이슈·PR 템플릿.

**English**

- Added the Korean edition, `trump-ko`. Its prompt is written in Korean, and it always replies in Korean.
  - It follows five core rules of the "translated Trump speech" style that Korean internet memes made famous: very short sentences, shameless self-praise, comparisons with the surroundings, simple English interjections (`SAD!`, `HAPPY!`, `FAKE NEWS!`), and a closing "이 문제에 관심을 가져주셔서 감사합니다!" every time.
  - It compares with the old code, the previous approach, or the alternatives, never with real politicians.
  - Its tone is tuned for persuasion and presentations. Deadpan certainty is the joke, and disagreement gets "Great point. Actually, I was thinking the same thing." before the model genuinely acts on it.
- The English edition, `trump`, also gained comparisons with the surroundings, evidence-only "Fake news!" rebuttals, and a way to take disagreement gracefully.
- Added Korean-edition adapters in `adapters/ko/` for Codex, Gemini CLI, Cursor, Copilot, and plain system prompts.
- `install.sh` installs both styles. Use `--style trump-ko` to install just one.
- Added Korean docs: a README centered on the Korean edition, Korean-edition transcripts, a contributing guide, and bilingual issue and PR templates.

## 1.0.0 (2026-10-13)

**한국어**

- 첫 릴리스입니다. 엄청납니다.
- Claude Code 아웃풋 스타일 `trump`를 추가했습니다. 영어와 한국어 표현집이 들어 있고, Claude Code의 코딩 지침을 유지합니다.
- 절대 원칙: 정확한 사실, 전문적인 산출물, 정직한 실패 보고, 평범한 문장으로 먼저 말하는 안전 경고, 정치 중립, 버그에만 붙이는 별명, 요청하거나 상황이 심각하면 꺼지는 말투.
- 강도 조절: `lite` / `살살`, `full rally` / `풀파워`, `stop` / `진지하게`.
- Claude Code 플러그인과 마켓플레이스(`/plugin install trump-style@trump-style`), 설치 스크립트 `install.sh`, 다른 에이전트용 어댑터, CI 구성을 추가했습니다.

**English**

- First release. Tremendous.
- Claude Code output style `trump` with English and Korean phrasebooks, keeping Claude Code's coding instructions.
- Golden rules: exact facts, professional artifacts, honest failure reports, plain safety warnings, no real-world politics, nicknames for bugs only, and a voice that switches off on request or in serious moments.
- Intensity controls: `lite` / `살살`, `full rally` / `풀파워`, and `stop` / `진지하게`.
- Claude Code plugin and marketplace (`/plugin install trump-style@trump-style`), `install.sh`, adapters for other agents, and CI.
