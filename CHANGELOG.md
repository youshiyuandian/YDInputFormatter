# Changelog

All notable changes to `YDInputFormatter` will be documented in this file.

## [0.1.3] - 2026-11-11

### Added

- Added an empty `PrivacyInfo.xcprivacy` privacy manifest declaring no tracking,
  no collected data types, and no Required Reason API usage
- Bundled the privacy manifest through CocoaPods `resource_bundles` for host
  app privacy report aggregation

## [0.1.2] - 2026-08-03

### Added

- Added `formattedTextFromText:` on `YDInputFormatter` for display-only text
  formatting without binding to `UITextField`
- Added `yd_setText:withFormatter:` on `UITextField` for directly assigning a
  raw value and showing the formatted result immediately

### Changed

- Updated the demo app to show pure display formatting and direct formatted text
  setting on `UITextField`
- Updated the English and Chinese README examples to cover the new display
  formatting APIs

## [0.1.1] - 2026-08-03

### Added

- Added manual delegate formatting support through
  `yd_formatWithFormatter:shouldChangeCharactersInRange:replacementString:`
- Added manual formatting refresh after assigning `textField.text` through
  `yd_applyFormattingWithFormatter:`

### Changed

- Updated the demo app to show automatic mode, business delegate mode, and
  manual text assignment formatting
- Updated the English and Chinese README examples to cover the new integration
  flows
- Kept the existing automatic delegate-wrapping mode compatible with the new
  manual APIs

## [0.1.0] - 2026-07-31

### Added

- Initial public release of `YDInputFormatter`
- Grouped input formatting for bank cards, phone numbers, identity numbers, and
  license keys
- Caret restoration for typing, deletion, middle insertion, and multi-character
  paste
- Chinese IME marked-text protection during composition
- CocoaPods packaging for iOS 13.0+
- Demo app included in the repository

[0.1.3]: https://github.com/youshiyuandian/YDInputFormatter/releases/tag/0.1.3
[0.1.2]: https://github.com/youshiyuandian/YDInputFormatter/releases/tag/0.1.2
[0.1.1]: https://github.com/youshiyuandian/YDInputFormatter/releases/tag/0.1.1
[0.1.0]: https://github.com/youshiyuandian/YDInputFormatter/releases/tag/0.1.0
