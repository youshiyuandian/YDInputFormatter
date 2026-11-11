# YDInputFormatter 0.1.3

This release adds an empty Apple privacy manifest so host apps can aggregate a
complete privacy report when integrating via CocoaPods.

## Highlights

- Added `PrivacyInfo.xcprivacy` declaring no tracking, no collected data types,
  and no Required Reason API usage
- Bundled the privacy manifest through CocoaPods `resource_bundles`
- Existing formatting APIs and integration modes remain unchanged

## Included in This Release

- `YDInputFormatter`
- `YDInputFormatterConfig`
- `YDInputFormatterResult`
- `UITextField+YDInputFormatter`
- `PrivacyInfo.xcprivacy`

## Installation

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.3'
```

If the CocoaPods CDN has not propagated to your environment yet, you can
temporarily install from GitHub:

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.3'
```

## Links

- GitHub: https://github.com/youshiyuandian/YDInputFormatter
- CocoaPods: https://cocoapods.org/pods/YDInputFormatter
