# YDInputFormatter

[English](README.md)

`YDInputFormatter` 是一个基于 Objective-C 的 `UITextField` 输入格式化组件，
适合银行卡号、手机号、身份证号、License Key 等分组输入场景，并尽量保证
输入、删除、中间插入和粘贴时的光标位置稳定。

## 特性

- 支持自定义前置分组和循环分组
- 支持自定义分隔符，例如空格和 `-`
- 支持原始内容最大长度限制
- 格式化后自动恢复合理的光标位置
- 支持多字符粘贴
- 删除分隔符时不破坏原始内容
- 中文输入法联想阶段不参与格式化
- 采用可复用的 `Engine + Config + Result + UITextField` 设计

## 环境要求

- iOS 13.0+
- ARC
- Objective-C

## 安装

### CocoaPods

```ruby
source 'https://cdn.cocoapods.org/'

pod 'YDInputFormatter', '0.1.0'
```

如果你当前环境里的 CocoaPods CDN 还没有同步到这个版本，可以先临时使用
GitHub tag 方式安装：

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.0'
```

## 快速开始

如果项目启用了模块：

```objc
@import YDInputFormatter;
```

也可以直接使用总头文件：

```objc
#import <YDInputFormatter/YDInputFormatter.h>
```

银行卡号示例：

```objc
YDInputFormatter *formatter = [[YDInputFormatter alloc] init];
formatter.separator = @" ";
formatter.prefixGroups = @[@4];
formatter.repeatGroupLength = 4;
formatter.maxLength = 16;

[self.cardTextField yd_enableFormatter:formatter];
```

身份证号示例，带自定义字符过滤：

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

## 对外 API

- `YDInputFormatter`
  业务层直接使用的高层格式化对象。
- `YDInputFormatterConfig`
  存储分组规则、分隔符、最大长度和字符过滤规则。
- `YDInputFormatterResult`
  返回格式化后的文本、原始文本以及计算出的光标偏移。
- `UITextField+YDInputFormatter`
  负责把格式化能力绑定到 `UITextField` 上。

## Demo

仓库自带同一份 Xcode 工程下的演示 App，目前覆盖：

- 银行卡号
- 手机号
- 身份证号
- License Key

## 链接

- GitHub: [youshiyuandian/YDInputFormatter](https://github.com/youshiyuandian/YDInputFormatter)
- CocoaPods: [YDInputFormatter](https://cocoapods.org/pods/YDInputFormatter)

## 开发与发布

本地校验 podspec：

```bash
pod lib lint YDInputFormatter.podspec --allow-warnings
```

发布新版本：

```bash
pod trunk push YDInputFormatter.podspec --allow-warnings
```

## License

MIT，详见 [LICENSE](LICENSE)。
