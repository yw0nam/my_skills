# my_skills

개인 스킬 저장소. 하나의 레포가 Claude Code 마켓플레이스이자 Codex 마켓플레이스다.
`skills/<name>/SKILL.md` 레이아웃을 두 CLI가 똑같이 읽으므로, 스킬 본문은 한 벌만 둔다.

## 설치

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

업데이트는 Claude Code `/plugin update`, Codex `codex plugin marketplace upgrade` 후 `codex plugin add` 재실행.

## 플러그인

| 이름 | 하는 일 |
|---|---|
| `design-doc-rules` | 설계문서·제안서·기술 문서·발표자료(한국어/영어)에서 기계 문체를 걷어내는 규칙 5절과 grep 기반 검사기 `check.sh` |

## 구조

```
.claude-plugin/marketplace.json     Claude Code 마켓플레이스 카탈로그
.agents/plugins/marketplace.json    Codex 마켓플레이스 카탈로그
plugins/<name>/
  .claude-plugin/plugin.json        Claude Code 매니페스트
  .codex-plugin/plugin.json         Codex 매니페스트 (interface 블록 필수)
  skills/<skill>/SKILL.md           두 CLI가 공유하는 스킬 본문
```

## 스킬 추가

1. `plugins/<name>/skills/<skill>/SKILL.md`를 만든다. frontmatter는 `name`, `description` 두 개.
2. 매니페스트 두 개를 기존 플러그인에서 복사해 값만 바꾼다. Codex 쪽은 `version`이 strict semver여야 하고 `interface.displayName`·`shortDescription`·`longDescription`·`developerName`·`category`·`capabilities`·`defaultPrompt`가 모두 있어야 한다.
3. 마켓플레이스 카탈로그 두 개에 항목을 추가한다.
4. 검증:

```
claude plugin validate plugins/<name> --strict
claude plugin validate . --strict
python3 ~/.codex/skills/.system/plugin-creator/scripts/validate_plugin.py plugins/<name>
```

스킬이 딸린 스크립트를 부를 때는 SKILL.md에 "이 스킬 디렉터리에서 실행한다"고 적는다.
두 CLI가 플러그인을 각자 다른 캐시 경로에 풀기 때문에 절대 경로를 박아두면 깨진다.
