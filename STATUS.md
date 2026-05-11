# Status

## Current Implementation

- `TextCalcCore/` contains a first-pass deterministic engine for:
  aggregate sum prompts,
  sequential arithmetic,
  binary arithmetic,
  powers,
  square,
  square root,
  direct expressions,
  preview formatting,
  and typed math / unsupported-input errors.
- `TextCalcApp/` contains a SwiftUI `MenuBarExtra` shell, a calculator popover, and a native hotkey bootstrap/fallback path.
- `project.yml` and `scripts/bootstrap-xcode-project.sh` define the canonical path to `TextCalcMenuBar.xcodeproj` generation once Xcode tooling is healthy.
- `TextCalcMenuBar.xcodeproj` has now been generated successfully from `project.yml`.
- `TextCalcUITests/TextCalcMenuBarUITests.swift` now verifies that the status item opens the calculator surface and that a representative sum prompt returns `28`.
- `.omx/plans/` contains the approved execution plan, PRD, and test spec.

## Verification Status

- `swift test --package-path TextCalcCore` succeeds.
- The user has confirmed `xcodebuild test -project TextCalcMenuBar.xcodeproj -scheme TextCalcMenuBar -destination 'platform=macOS'` succeeds on the local machine.
- Codex sandbox verification remains incomplete because Xcode / SwiftPM in this environment cannot write to the user cache paths under `/Users/renboyang/.cache` and `/Users/renboyang/Library/Caches`.

## Known Constraints

- v1 remains intentionally deterministic and offline.
- Unit conversion, currency conversion, and broader free-form reasoning are still out of scope.
