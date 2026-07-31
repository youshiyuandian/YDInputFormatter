# YDInputFormatter

`YDInputFormatter` is an Objective-C input formatting component for `UITextField`.
It focuses on grouped input such as bank cards, phone numbers, identity numbers,
and license keys, while keeping caret movement stable during typing, deletion,
middle insertion, and paste.

## Features

- Arbitrary prefix groups and repeat groups
- Custom separators such as `" "` and `"-"`
- Maximum raw length limiting
- Caret restoration after formatting
- Paste handling for multiple characters
- Deleting separators without breaking raw content
- Skips formatting during Chinese IME marked text input
- Reusable `Engine + Config + Result + UITextField` adapter design

## Requirements

- iOS 13.0+
- ARC
- Objective-C

## Installation

### CocoaPods

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.0'
```

After the pod is published to CocoaPods Trunk, you can also use:

```ruby
pod 'YDInputFormatter'
```

## Quick Start

If your project enables modules:

```objc
@import YDInputFormatter;
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

Identity number example with custom character filter:

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
  The high-level formatter object used by business code.
- `YDInputFormatterConfig`
  Stores grouping, separator, max length, and custom filter rules.
- `YDInputFormatterResult`
  Returns formatted text, raw text, and the calculated caret offset.
- `UITextField+YDInputFormatter`
  Binds a formatter to a text field and takes over input formatting.

## Project Layout

```text
YDInputFormatter/
├── YDInputFormatter/
│   ├── Formatter/
│   │   ├── Core/
│   │   └── UIKit/
│   └── ...
├── YDInputFormatter.podspec
├── README.md
└── LICENSE
```

## Local Demo

This repository includes a demo app target in the same Xcode project.
The demo currently covers:

- Bank card
- Phone number
- Identity number
- License key

## Repository

- GitHub: [youshiyuandian/YDInputFormatter](https://github.com/youshiyuandian/YDInputFormatter)

## Release Checklist

Then run:

```bash
pod lib lint YDInputFormatter.podspec --allow-warnings
```

If you want to publish to CocoaPods Trunk:

```bash
pod trunk push YDInputFormatter.podspec --allow-warnings
```
