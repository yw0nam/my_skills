#!/usr/bin/env bash
# Usage: check.sh FILE  — prints "class<TAB>line:text" for every candidate; exit 1 when any hit remains.
set -u
f="$1"; n=0
hit() { local o; o=$(grep -n${3:-} -E "$2" "$f"); [ -n "$o" ] && { printf '%s\n' "$o" | sed "s/^/$1\t/"; n=1; }; }
# Korean
hit contrast "아니라|아닌|대신|않고|않음|없음|없이|않습니다|없습니다|않는|한 번에|따로|필요해지면|기존|이번|더 이상|굳이"
hit calque   "입구|받습니다|업그레이드|교환|같은 꼴|코스|드롭|이벤트|루브릭|등급|히스테리시스"
hit abbrev   "L 도구|정의 75K|결과·첨부|큰 결과"
hit filler   "다양한|효과적으로|원활하게|강력한|핵심적인|중요한 점은|참고로|기본적으로|명확하게|특히|물론|또한|뿐만 아니라|을 통해|에 대한|수 있습니다|하는 것이 중요|보장합니다|제공합니다"
hit meta     "즉,|결론적으로|요약하면|정리하면|같은 이유로|그래서 |위에서|앞서|살펴보|알 수 있|주목할|—"
# English
hit contrast "\b(not|no|never|none|without|unlike|previously|existing|currently|separately)\b|instead of|rather than|no longer|at once|(if|when) needed|for now|for later|added later" i
hit jargon   "\b(handles?|trade-?offs?|upgrade path|rubric|hysteresis)\b" i
hit abbrev   "\b[A-Z] (tool|tier|grade)s?\b|\b(tier|grade|class) [A-Z]\b"
hit filler   "\b(leverage|robust|seamless(ly)?|comprehensive|ensure|crucial|key|essentially|basically|simply|streamline|empower|holistic|delve|various|effectively)\b|in order to|it is important" i
hit meta     "worth noting|importantly|note that|in other words|in summary|overall|as (mentioned|described|shown) (above|earlier)|for the same reason|as (the )?(table|figure) shows|this (section|document) (describes|covers)|—" i
exit $n
