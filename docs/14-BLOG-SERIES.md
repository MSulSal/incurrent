# Blog Series Plan

Goal: publish engineering writeups that show judgment, tradeoffs, and measurable outcomes.

## Style Rules

1. Write from real artifacts (benchmarks, logs, dashboards).
2. Include failures and wrong turns, not only wins.
3. End each post with what changed in the system.
4. Add a technical takeaway section in each article.

## Planned Posts

1. Why I built Incurrent instead of another CRUD app.
2. Idempotency under at-least-once delivery: what actually works.
3. Hot-key meltdown and striping strategy.
4. Backpressure design: choosing graceful degradation over collapse.
5. Replay and rebuild: recovering state from event logs.
6. Failure drills and operational maturity in a distributed system.

## Existing Drafts

1. `docs/blog/2026-03-03-why-incurrent.md`
2. `docs/blog/2026-03-03-correctness-under-retries.md`
3. `docs/blog/2026-03-03-hot-key-striping.md`

## Publishing Checklist

1. Add architecture diagram or sequence flow.
2. Include benchmark table with conditions.
3. Include at least one footgun and lesson learned.
4. Link related issue IDs and commits.
5. Update private summary notes with any new measurable results.
