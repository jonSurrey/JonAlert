# CLAUDE.md

How to work in this repository. Keep it lean.

## What this is

**JonAlert** — a feedback alert for iOS (like Spotify's). A short message, with an optional icon,
appears in the middle of the screen and fades away. A small, dependency-free Swift package with a
UIKit API and a SwiftUI modifier.

- Swift 6 language mode, strict concurrency. iOS 16+.
- Swift Package Manager only. No CocoaPods, Carthage, or Objective-C support.
- Zero third-party dependencies. Ask before adding one.
- One alert is visible at a time, app-wide. Others wait in order and are all shown.
- `show(in:)` is `async` and returns once the alert has gone. Cancelling the task removes a waiting
  alert or dismisses the visible one.

## Architecture

The code is **one piece of pure logic** (the queue) and a **thin UIKit layer**. That is the whole
architecture — don't add layers, coordinators, view models, or folders on top of it.

| File | Owns | Must not contain |
|---|---|---|
| `Sources/JonAlert/FeedbackAlert.swift` | The public alert value (message, icon, duration) and `show(in:)` | Queue rules, drawing |
| `Sources/JonAlert/View+FeedbackAlert.swift` | The SwiftUI modifier | Queue rules, drawing |
| `Sources/JonAlert/AlertQueue.swift` | Which alert is showing and which one comes next | `import UIKit`, views, animation |
| `Sources/JonAlert/AlertPresenter.swift` | Connecting the queue to windows: one app-wide queue, each alert in its own view's window | Queue rules, drawing |
| `Sources/JonAlert/AlertView.swift` | Drawing and animating one alert | Decisions about order or timing |
| `Tests/JonAlertTests/` | Unit tests for `AlertQueue` | — |
| `Example/` | A demo app that uses the package | Library code |

- `AlertQueue` is a plain value type and `Sendable`. It imports Foundation only, so it is fully
  unit-testable.
- `AlertPresenter` and `AlertView` are `internal`. Clients only see `FeedbackAlert` and the modifier.
- The window is read from the view passed to `show(in:)` (in SwiftUI, from the modifier's own view) —
  never `keyWindow`, never `UIScreen.main`.
- Every alert is announced to VoiceOver, fades without moving under Reduce Motion, and scales with
  Dynamic Type. Colors adapt to dark mode.

## Non-negotiable

- **Simplest correct solution wins.** If a piece of logic is hard to explain in one or two sentences,
  stop and redesign it before writing more.
- **No hacks or workarounds.** No `DispatchQueue.main.asyncAfter` to "fix" timing, no magic offsets
  to make something line up, no catching and ignoring a problem. If the code is heading that way, stop,
  find the root cause, and revise the design.
- No force unwrap, `try!`, or `as!`. No `fatalError` in reachable code.
- No `nonisolated(unsafe)`, `@unchecked Sendable`, or `@preconcurrency` to silence the compiler.
  UIKit-facing types are `@MainActor`.
- No magic numbers. Sizes, spacings, and timings live in named constants.
- Public API is minimal and deliberate: `public`, never `open`. Value types by default; `class` only
  where UIKit or shared state requires it.
- Priority when these conflict: **Correctness → Simplicity → Readability → Performance.**

## Comments

Code explains itself through names. **The default is no comment.**

A comment is allowed only to give context that the code cannot show, or to explain unavoidable
non-obvious logic. One short line. Never:

- restate what the code or the name already says (`/// The message of the alert`)
- narrate history, alternatives, or decisions ("we used to…", "instead of X…")
- leave commented-out code, TODOs without an owner, or ticket references
- add doc comments to `internal`/`private` members just to have them

Public API gets a brief doc comment only when usage isn't obvious from the signature.

## Testing

- Every rule in `AlertQueue` has a unit test. Views are verified in the Example app.
- Tests use Swift Testing, are deterministic, test one behavior each, and have a display name that
  states the behavior (`@Test("An alert queued while another is showing waits its turn")`).
- The package is iOS-only, so `swift build` on macOS won't work. Run tests on a shut-down simulator with
  `xcodebuild test -scheme JonAlert -destination 'platform=iOS Simulator,id=<simulator id>' -parallel-testing-enabled NO`.
- macOS has no `timeout` command. Run long commands in the background instead of wrapping them.

## Git workflow

- `main` is protected and holds released code only. Never commit to it directly.
- All work branches off `development` and goes back through a PR into `development`.
- Stacked changes: each PR targets the previous PR's branch, so its diff shows only its own change.
- Never merge a PR yourself; the owner merges. Afterwards, delete merged local branches with `git branch -d`.
- Release: open a PR `development` → `main`, merge it with a merge commit, then tag `main` with a
  semantic version without a `v` (`2.0.0`) and create the GitHub release from that tag.
- One logical change per commit and per PR. Don't mix a refactor with a behavior change.
- Conventional commits: `feat(queue): show one alert at a time`, `fix(alert): …`,
  `chore(spm): …`, `docs(readme): …`, `test(queue): …`.

## How work gets done

- Plan before multi-file or architectural changes and explain the approach first.
- Change the minimum code needed. Don't tidy unrelated code in the same diff.
- Surface any architectural decision and its tradeoff — never make one silently.
- After implementing, briefly say why this approach and what was rejected.

## Spec workflow

- `/spec-plan <problem>` — a fresh Opus session plans against `origin/development`. The plan is saved to
  `tasks/` only after it passes every readiness gate and an independent review, at 80%+ confidence.
- `/spec-execute [plan]` — a fresh Sonnet session implements a ready plan, checks the diff against it,
  opens a PR into `development`, and deletes the plan. If it can't follow the plan, it marks the plan
  blocked instead of improvising.
- `/spec-review <what's wrong>` — an Opus session reviews what `/spec-execute` did and saves a fix plan
  to `tasks/`.

`tasks/` is git-ignored: plans are working files, and each executed plan is kept in its PR's body.
