---
name: design-doc-rules
description: Rules and a runnable checker that strip machine-flavoured prose from design documents, proposals, technical docs, and slide decks in Korean or English. Read before writing, revising, or reviewing any such document. (설계문서·제안서·기술 문서·발표자료를 작성·수정·검토할 때 먼저 읽는다.)
---

# Design document rules

Applies in any repo, to Korean or English prose. The target is text a senior engineer wrote by hand: plain words, one claim per sentence, every number sourced.

## Procedure

1. Draft or edit under sections 1–5.
2. Run `check.sh FILE` from this skill's directory. Rewrite every hit under its rule and run again. Done when every remaining hit is one of: the problem statement, a drawback of a rejected alternative, a metric name, a literal value, or a word used in its plain technical sense (e.g. "key" as a dictionary key).
3. Read-check what grep cannot see: every number in the body traces to the assumptions table (3.5); every condition can occur (3.3); every borrowed justification agrees with this document's tables (3.4); every threshold and stage states what it buys (3.2).

## 1. Words

1. Spell every term out. "L 도구" → "도구 정의 75K"; "results/attachments" → "tool results and attachments".
2. State a condition as the condition. "결과 크기 등급 L" → "결과가 8K를 넘는 도구"; "tier-L result" → "a result over 8K".
3. Use the document's own language. Korean calques ("입구를 지킨다", "~로 받는다", "교환", "드롭", "이벤트", "루브릭", "히스테리시스") become Korean words ("태그 필터", "버린다", "트리거", "채점 기준"). English vague verbs ("handle", "leverage", "ensure") become the concrete action.
4. Metrics and scoring criteria list their items. "4-item rubric, 0–2 each" → "Score each answer yes/no on four points: main point, adherence to the initial condition, only the necessary calls, failure reported."
5. Intensifiers and evaluative adjectives ("robust", "seamless", "comprehensive", "다양한", "효과적으로", "강력한", "핵심적인") are replaced by the measurable property or deleted.

## 2. Sentences

1. Keep only the B half of "not A but B" / "A rather than B" / "A가 아니라 B" / "대신" / "~않고 ~한다".
2. One subject per sentence, stated once. "The main agent stays; the main agent's role becomes …" → "The main agent owns planning, dialogue understanding, answer synthesis, and delegation; three components own the rest."
3. Short declaratives, each following from the previous one. Connectives that only signal continuation ("또한", "특히", "물론", "additionally", "importantly") are deleted; the sentence stands on its content.
4. Tables and figures carry the document's logic; sentences that re-narrate it ("so there is no need to …", "as the table shows", "즉", "같은 이유로", "~가 표에서 바로 읽힙니다") are deleted. When no explanation is needed, write no sentence.
5. Register: Korean body in 습니다체, English body in present-tense declaratives. "~할 수 있습니다" / "can" only for genuine ability or permission; a fact is "~합니다" / present tense. Table cells and definition-list values end in a noun phrase.
6. Parallel items are a numbered list `1. 2. 3.`; ordered steps only use ①②③. A list has as many items as there are; padding or trimming to three distorts.
7. Punctuation: commas and full stops. Em-dashes (—) become a full stop or a comma.

## 3. Content

1. Write what the design does. Two exceptions may say what something does not do: the problem statement and the drawbacks of rejected alternatives. Everything else of that kind ("no re-execution", "added when needed", "재실행 없음", "따로 보호하지 않는다") is deleted.
2. Every stage, threshold, and condition states in numbers what it buys. When it cannot, take the simpler form: two thresholds → one, two stages → one pass.
3. Every condition can occur. Counter-example: "stop if savings < 10%" in a design that already summarises the middle segment to ≤10K.
4. A justification borrowed from another design or a public implementation is checked against this document's tables first. Counter-example: "summaries are irreversible" beside a table storing old-turn originals.
5. Numbers (thresholds, caps, ratios) live in one place, the assumptions table; the body cites it.
6. A slide deck stands alone: assumption values are on the slide, in place of pointers into the design doc ("full table in design doc table 8").
7. Submissions carry no private code, documents, API details, logs, or real data from a current or former employer. Public sources are cited.

## 4. Structure

1. The document ends with its last substantive section. Closing summaries, "결론적으로", "In summary" paragraphs, and sections that restate earlier ones are deleted.
2. Headings mark places a reader jumps to. A paragraph gets no heading of its own.
3. Bold marks a term at its definition, once. Bold-lead bullets ("**Term**: explanation") become plain sentences or a definition list. Emoji do not appear.
4. Sentences about the document itself ("this section describes", "앞서 살펴본 대로") are deleted; the content is stated directly.

## 5. Revision

1. A sentence the user wrote by hand keeps its content; only typos and endings change.
2. A changed decision takes with it every sentence, table row, figure label, and trace field it produced. Example: compression stages abolished → the trace field `stage` goes too.
3. Read each rule wider than the example that produced it: one fix means a whole-document search for the same kind.
