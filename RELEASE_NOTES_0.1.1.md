# YDInputFormatter 0.1.1

This release adds two integration-friendly APIs for teams that prefer to keep
their own `UITextFieldDelegate` flow or assign text programmatically.

## Highlights

- Added manual delegate formatting support through
  `yd_formatWithFormatter:shouldChangeCharactersInRange:replacementString:`
- Added manual formatting refresh after assigning `textField.text` through
  `yd_applyFormattingWithFormatter:`
- Updated the demo app and README examples to cover automatic mode, business
  delegate mode, and manual text assignment formatting
- Existing automatic delegate-wrapping mode remains supported

## Included in This Release

- `YDInputFormatter`
- `YDInputFormatterConfig`
- `YDInputFormatterResult`
- `UITextField+YDInputFormatter`

## Installation

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.1'
```

If the CocoaPods CDN has not propagated to your environment yet, you can
temporarily install from GitHub:

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.1'
```

## Links

- GitHub: https://github.com/youshiyuandian/YDInputFormatter
- CocoaPods: https://cocoapods.org/pods/YDInputFormatter
