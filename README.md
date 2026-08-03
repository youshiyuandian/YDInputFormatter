# YDInputFormatter

[简体中文](README.zh-CN.md)

`YDInputFormatter` is an Objective-C input formatting component for `UITextField`.
It is designed for grouped input such as bank cards, phone numbers, identity
numbers, and license keys while keeping caret movement stable during typing,
deletion, middle insertion, and paste.

## Highlights

- Flexible prefix groups and repeat groups
- Custom separators such as `" "` and `"-"`
- Maximum raw length limiting
- Stable caret restoration after formatting
- Multi-character paste handling
- Safe separator deletion without breaking raw content
- Skips formatting during Chinese IME marked text input
- Reusable `Engine + Config + Result + UITextField` adapter design

## Requirements

- iOS 13.0+
- ARC
- Objective-C

## Installation

### CocoaPods

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.0'
```

If the CocoaPods CDN has not propagated to your environment yet, you can
temporarily install from GitHub:

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.0'
```

## Quick Start

If your project enables modules:

```objc
@import YDInputFormatter;
```

Or use the umbrella header:

```objc
#import <YDInputFormatter/YDInputFormatter.h>
```

Bank card example:

```objc
YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
formatter.separator = @" ";
formatter.prefixGroups = @[@4];
formatter.repeatGroupLength = 4;
formatter.maxLength = 16;

[self.cardTextField yd_enableFormatter:formatter];
```

Identity number example with a custom character filter:

```objc
YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
formatter.separator = @" ";
formatter.prefixGroups = @[@6, @8];
formatter.repeatGroupLength = 4;
formatter.maxLength = 18;
formatter.filter = ^BOOL(unichar character) {
    if ([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:character]) {
        return YES;
    }
    return character == 'X' || character == 'x';
};

[self.identityTextField yd_enableFormatter:formatter];
```

## Public API

- `YDInputFormatter`
  High-level formatter object used by business code.
- `YDInputFormatterConfig`
  Stores grouping, separator, max length, and custom filter rules.
- `YDInputFormatterResult`
  Returns formatted text, raw text, and the calculated caret offset.
- `UITextField+YDInputFormatter`
  Binds a formatter to a text field and takes over input formatting.

## Integration Notes

- Set your business delegate before calling `yd_enableFormatter:` and avoid
  replacing `textField.delegate` afterwards. The formatter installs its own
  delegate wrapper and forwards callbacks to the previous delegate.
- In `textField:shouldChangeCharactersInRange:replacementString:`, let your
  external delegate decide allow or deny only. Avoid mutating `textField.text`,
  `selectedTextRange`, or running another formatter there.
- `editingChanged` observers receive the formatted text after the formatter has
  handled the input. Avoid rewriting text or caret position again in those
  callbacks to prevent jumps or double-processing.
- If you assign `textField.text` programmatically, the text may need an
  additional formatting pass. Refresh the field with the formatter before
  relying on the displayed result.
- Chinese IME marked text is intentionally skipped during composition. This is
  usually correct, but you should still test with the keyboards and input
  methods used by your app.
- `textField.text` is the formatted display value. If your backend needs the
  raw value without separators, extract or recompute the raw text explicitly.
- This library is best suited for short structured inputs such as bank cards,
  phone numbers, identity numbers, and license keys. It is not intended for
  rich text or complex Unicode editing scenarios.

## Demo

This repository includes a demo app target in the same Xcode project. The demo
currently covers:

- Bank card
- Phone number
- Identity number
- License key

## Links

- GitHub: [youshiyuandian/YDInputFormatter](https://github.com/youshiyuandian/YDInputFormatter)
- CocoaPods: [YDInputFormatter](https://cocoapods.org/pods/YDInputFormatter)

## Development

Validate the podspec locally:

```bash
pod lib lint YDInputFormatter.podspec --allow-warnings
```

Publish a new version:

```bash
pod trunk push YDInputFormatter.podspec --allow-warnings
```

## License

MIT. See [LICENSE](LICENSE).
