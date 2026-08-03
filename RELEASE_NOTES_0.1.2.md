# YDInputFormatter 0.1.2

This release extends the formatter beyond input interception and adds two APIs
for display-only formatting scenarios.

## Highlights

- Added `formattedTextFromText:` on `YDInputFormatter` for converting raw text
  into a formatted display string without using `UITextField`
- Added `yd_setText:withFormatter:` on `UITextField` for directly assigning a
  raw value and showing the formatted result immediately
- Updated the demo app and README examples to cover pure display formatting and
  formatted text assignment on `UITextField`
- Existing automatic mode, manual delegate mode, and manual refresh mode remain
  supported

## Included in This Release

- `YDInputFormatter`
- `YDInputFormatterConfig`
- `YDInputFormatterResult`
- `UITextField+YDInputFormatter`

## Installation

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.2'
```

If the CocoaPods CDN has not propagated to your environment yet, you can
temporarily install from GitHub:

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.2'
```

## Links

- GitHub: https://github.com/youshiyuandian/YDInputFormatter
- CocoaPods: https://cocoapods.org/pods/YDInputFormatter
