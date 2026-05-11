# TextCalc

TextCalc is a local-first macOS menu-bar calculator for bounded Chinese natural-language arithmetic and standard expressions.

## Current State

- `TextCalcCore/` contains the deterministic normalization, parsing, evaluation, and formatting engine.
- `TextCalcApp/` contains the SwiftUI menu-bar shell, hotkey bootstrap/fallback behavior, and calculator surface.
- `project.yml` defines the canonical Xcode project shape for `TextCalcMenuBar.xcodeproj`.
- `TextCalcUITests/` contains a working macOS UI test entry that opens the menu-bar popover and validates a representative calculation flow.
- `TextCalcTests/Fixtures/` documents supported and unsupported acceptance cases.

## Supported Scope

- Natural-language sum prompts such as `1 2 3 4 5 6 7 这几个数字求和`
- Standard arithmetic expressions such as `(12 + 5) * 3`
- Sequential arithmetic phrasing, powers, square, and square root
- Unsupported inputs fail clearly, for example unit conversion requests are out of scope in v1

## Bootstrap

- Generate or refresh the Xcode project with `scripts/bootstrap-xcode-project.sh`.
- Run core tests with `swift test --package-path TextCalcCore`.
- Run app and UI tests with `xcodebuild test -project TextCalcMenuBar.xcodeproj -scheme TextCalcMenuBar -destination 'platform=macOS'`.
