# YDInputFormatter 0.1.0

Initial public release of `YDInputFormatter`, an Objective-C `UITextField`
input formatting component for grouped text entry on iOS.

## Highlights

- CocoaPods library release with iOS 13.0 as the minimum deployment target
- Flexible grouped formatting for bank cards, phone numbers, identity numbers,
  and license keys
- Stable caret handling for typing, deletion, middle insertion, and
  multi-character paste
- Chinese IME marked-text protection during composition
- Demo app included in the repository

## Included in This Release

- `YDInputFormatter`
- `YDInputFormatterConfig`
- `YDInputFormatterResult`
- `UITextField+YDInputFormatter`

## Installation

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.0'
```

If the CocoaPods CDN has not propagated to your environment yet, you can
temporarily install from GitHub:

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.0'
```

## Links

- GitHub: https://github.com/youshiyuandian/YDInputFormatter
- CocoaPods: https://cocoapods.org/pods/YDInputFormatter
