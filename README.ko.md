# trump-style

**Claude Code 최고의 아웃풋 스타일. 엄청납니다. 다들 그렇게 말해요.**

[![CI](https://github.com/DongHyunTedKim/trump-style/actions/workflows/ci.yml/badge.svg)](https://github.com/DongHyunTedKim/trump-style/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-d97757.svg)](#claude-code-플러그인-추천)

[English](README.md) | 한국어

trump-style은 Claude Code와 여러 AI 코딩 에이전트의 말투를 트럼프식으로 바꿔 줍니다. 코드를 읽고, 판단하고, 고치고, 테스트하고, 보고하는 방식은 그대로입니다. 말투만 유세 현장처럼 바뀝니다.

## 비교해 보세요

같은 버그(`cart.js`의 범위 초과 루프와 잘못된 할인 계산)를 같은 프롬프트로 맡겼습니다. 둘 다 Claude Code의 실제 출력이며, 손대지 않았습니다.

**프롬프트:** `이 레포 테스트가 깨져. 버그 찾아서 고치고 node --test로 확인해줘.`

**기본 스타일**

> `cart.js`에서 버그 두 개를 고쳤고, 이제 `node --test`에서 테스트 3개가 모두 통과해.
>
> 1. **반복문 범위 초과** (`cart.js:5`): `i <= items.length` 조건 때문에 배열 끝을 하나 넘겨서 `items[i]`가 `undefined`가 됐어. (…)
> 2. **할인 계산 오류** (`cart.js:9`): 할인율(0.1, 0.5)을 금액에서 그대로 빼고 있었어. (…)
>
> 커밋은 아직 안 했어.

**trump-style**

> 고쳤습니다. 아주 아름답게 고쳤어요. `node --test`를 다시 돌렸더니 3개 중 3개 통과, 실패 0개입니다. 완벽한 점수예요. 믿어주세요.
>
> | 위치 | 문제 | 수정 |
> |---|---|---|
> | `cart.js:5` | '한 칸 넘는 루프'가 `i <= items.length`라서 배열 끝을 하나 넘어갑니다. (…) 이 때문에 테스트 3개가 전부 터졌어요 | `i < items.length` |
> | `cart.js:9` | '엉터리 할인'이 할인율을 곱하지 않고 그냥 뺐습니다. SAVE10을 쓰면 25에서 0.1만 빠져서 24.9가 나와요. 슬픈 일입니다! | `total * (1 - discounts[code])` |
>
> 솔직히 말해서 두 번째 버그가 더 교활했습니다. 첫 번째 버그가 모든 테스트를 먼저 터뜨려서 두 번째 버그를 가리고 있었거든요. 아주, 아주 교활했어요. 이제 둘 다 끝났습니다. 대승리!
>
> 커밋은 아직 안 했어요. 말씀만 하시면 바로 하겠습니다. 이 테스트 스위트를 다시 위대하게!

두 세션 모두 코드 수정 내용은 똑같았습니다. 영어 응답, 커밋 메시지, 정치 질문, 운영 장애 상황을 포함한 전체 기록은 [실제 대화 기록](examples/README.md)에서 볼 수 있습니다.

## 설치

### Claude Code 플러그인 (추천)

Claude Code 안에서 실행하세요.

```text
/plugin marketplace add DongHyunTedKim/trump-style
/plugin install trump-style@trump-style
/output-style trump-style:trump
```

터미널에서 설치해도 됩니다.

```bash
claude plugin marketplace add DongHyunTedKim/trump-style
claude plugin install trump-style@trump-style
```

설치한 뒤 Claude Code에서 `/output-style trump-style:trump`를 실행하거나, `/config`를 열어 **Output style**에서 고르면 됩니다. 새 버전은 `/plugin marketplace update trump-style`로 받습니다.

### 한 줄 설치 스크립트

```bash
curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash
```

스타일 파일을 `~/.claude/output-styles/trump.md`에 복사합니다. 그다음 `/output-style trump`로 켜면 됩니다. 현재 프로젝트에만 설치하려면 `bash` 뒤에 `-s -- --project`를, 지우려면 `-s -- --uninstall`을 붙이세요.

### 직접 복사

[`output-styles/trump.md`](output-styles/trump.md)를 내려받아 모든 프로젝트에 쓰려면 `~/.claude/output-styles/`에, 한 프로젝트에만 쓰려면 `.claude/output-styles/`에 넣으세요. 그다음 `/output-style trump`를 실행합니다.

Windows(PowerShell)에서는 이렇게 합니다.

```powershell
New-Item -ItemType Directory -Force "$HOME\.claude\output-styles" | Out-Null
Invoke-WebRequest https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/output-styles/trump.md -OutFile "$HOME\.claude\output-styles\trump.md"
```

### 기본값으로 쓰기

`~/.claude/settings.json`에 `outputStyle`을 지정하세요. 대소문자를 구분합니다.

```json
{ "outputStyle": "trump-style:trump" }
```

스크립트나 직접 복사로 설치했다면 값은 `"trump"`입니다.

## 다른 AI 에이전트

같은 프롬프트를 하나의 원본에서 도구별 형식으로 생성해 두었습니다. 처음부터 끝까지 검증한 것은 Claude Code뿐이고, 다른 에이전트에서는 쓰는 모델에 따라 결과가 달라질 수 있습니다.

| 에이전트 | 파일 | 넣을 위치 |
|---|---|---|
| Codex CLI | [`adapters/AGENTS.md`](adapters/AGENTS.md) | `~/.codex/AGENTS.md` 끝에 추가 |
| Gemini CLI | [`adapters/GEMINI.md`](adapters/GEMINI.md) | `~/.gemini/GEMINI.md` 끝에 추가 |
| Cursor | [`adapters/cursor/trump-style.mdc`](adapters/cursor/trump-style.mdc) | `.cursor/rules/`에 복사 |
| GitHub Copilot | [`adapters/copilot-instructions.md`](adapters/copilot-instructions.md) | `.github/copilot-instructions.md` 끝에 추가 |
| OpenCode, Amp 등 `AGENTS.md`를 읽는 에이전트 | [`adapters/AGENTS.md`](adapters/AGENTS.md) | 에이전트의 전역 `AGENTS.md` 끝에 추가 |
| Claude.ai, ChatGPT, API, Agent SDK | [`adapters/system-prompt.md`](adapters/system-prompt.md) | 맞춤 지침, 프로젝트 지침, 시스템 프롬프트에 붙여넣기 |

가능하면 개인 전역 설정 파일에 넣으세요. 프로젝트의 `AGENTS.md`나 규칙 파일은 그 레포에서 일하는 모든 사람에게 적용됩니다. 동료가 터미널에서 유세를 듣고 싶어 하지 않을 수도 있어요.

## 바뀌는 것과 그대로인 것

| 바뀌는 것 | 그대로인 것 |
|---|---|
| 대화창에서 Claude가 사용자에게 하는 말 | 코드, 주석, 커밋 메시지, PR 설명, 파일에 쓰는 모든 내용 |
| 최상급 표현, 반복, "슬픈 일입니다!", "대승리!" 같은 한마디 판정 | 사실 정보: 숫자, 경로, 줄 번호, 테스트 결과, 오류 메시지 |
| '비뚤어진 캐시', '기운 없는 루프' 같은 버그 별명 | Claude Code의 소프트웨어 엔지니어링 지침(`keep-coding-instructions: true`) |
| 가끔 나오는 "이 문제에 관심 가져주셔서 감사합니다!" | 삭제나 보안처럼 위험한 작업의 경고. 항상 평범한 문장으로 먼저 말합니다 |

## 기본 안전장치

- **정치 중립.** 패러디 대상은 말투뿐입니다. 실제 정치 질문을 받으면 평소 말투로 중립적으로 답하고, 코드 이야기로 돌아오면 다시 캐릭터를 잡습니다. [실제 기록 보기](examples/README.md#4-real-world-politics-the-persona-steps-aside)
- **사람이 아니라 버그를 공격합니다.** 별명과 "재앙" 같은 표현은 버그, 불안정한 테스트, 기술 부채에만 씁니다. 사용자나 동료, 실존 인물이나 집단을 겨냥하지 않습니다.
- **정직합니다.** 실패, 불확실성, Claude 자신의 실수는 그대로 보고합니다. 과장은 형용사에만 쓰고 데이터에는 쓰지 않습니다.
- **멈출 때를 압니다.** "진지하게"나 "그만"이라고 하거나 운영 장애 같은 상황이 오면 말투를 끕니다. [실제 기록 보기](examples/README.md#5-be-serious-the-persona-switches-off)

## 강도 조절

| 이렇게 말하면 | 이렇게 됩니다 |
|---|---|
| `살살` / `lite` | 한 답변에 한두 번만 양념 |
| `풀파워` / `full rally` | 안전장치 안에서 최대 강도 |
| `진지하게`, `그만`, `stop`, `normal mode` | 다시 요청할 때까지 평소 말투 |
| `/output-style default` | 스타일 끄기 |

## 언어

Claude는 사용자의 언어로 답하고, 영어 표현을 직역하는 대신 그 언어에 맞게 말투를 바꿉니다. 프롬프트에는 영어와 한국어 전용 표현집이 들어 있습니다. 한국어는 익숙한 '트럼프 연설 번역투'를 씁니다. 존댓말에 짧고 힘 있는 문장, 그리고 "믿어주세요", "엄청난", "슬픈 일입니다!", "이 테스트 스위트를 다시 위대하게!" 같은 표현이 특징입니다.

## 자주 묻는 질문

**코드 품질이 떨어지지 않나요?**
아닙니다. 이 스타일은 Claude Code의 엔지니어링 지침을 유지하고(`keep-coding-instructions: true`), 대화 문장만 바꿉니다. 테스트에서도 코드 수정과 커밋 메시지는 평소처럼 깔끔했습니다.

**토큰이 얼마나 더 드나요?**
시스템 프롬프트에 약 13KB의 지침이 추가됩니다. 세션의 첫 요청 이후에는 프롬프트 캐싱 덕분에 비용이 크게 줄어듭니다. 답변 길이는 평소와 비슷합니다.

**서브에이전트에도 적용되나요?**
아닙니다. Claude Code는 아웃풋 스타일을 메인 대화와 포크에만 적용합니다. 다른 서브에이전트는 각자의 시스템 프롬프트로 동작합니다.

**플러그인으로 설치하면 왜 `trump-style:trump`인가요?**
Claude Code는 플러그인 구성 요소 이름 앞에 플러그인 이름을 붙입니다. 스크립트나 직접 복사로 설치하면 그냥 `trump`로 등록됩니다.

**제 입맛대로 고쳐도 되나요?**
물론입니다. `output-styles/trump.md`를 `~/.claude/output-styles/`에 복사하고, 프런트매터의 `name`을 바꾼 다음 마음껏 수정하세요. 개선 사항을 기여하려면 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요.

## 삭제

- 플러그인: `/plugin uninstall trump-style@trump-style`
- 스크립트: `curl -fsSL https://raw.githubusercontent.com/DongHyunTedKim/trump-style/main/install.sh | bash -s -- --uninstall`
- 직접 복사: `~/.claude/output-styles/trump.md` 삭제

설정의 `outputStyle`이 아직 이 스타일을 가리키고 있다면 `/output-style default`를 실행하세요.

## 고지

이 프로젝트는 널리 알려진 공인의 말투를 재미로 흉내 낸 패러디입니다. Donald J. Trump, The Trump Organization, 어떤 정치 캠프나 정당, 그리고 Anthropic과도 관련이 없으며 이들의 승인이나 후원을 받지 않았습니다. 정치적 입장을 취하지 않으며, 프롬프트도 모델이 정치 이야기를 피하도록 지시합니다.

## 라이선스

[MIT](LICENSE)
