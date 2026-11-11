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

pod 'YDInputFormatter', '0.1.3'
```

如果你当前环境里的 CocoaPods CDN 还没有同步到这个版本，可以先临时使用
GitHub tag 方式安装：

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.3'
```

## 快速开始

### 自动接管 delegate 模式

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

### 业务 delegate 手动格式化模式

如果你希望继续保留自己的 `UITextFieldDelegate`，可以在业务代理方法里这样写：

```objc
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    return [textField yd_formatWithFormatter:self.phoneFormatter
               shouldChangeCharactersInRange:range
                           replacementString:string];
}
```

### 不依赖 `UITextField` 的纯文本格式化显示

如果你只需要一个格式化后的展示字符串，可以直接这样用：

```objc
NSString *formattedText = [self.phoneFormatter formattedTextFromText:@"13812345678"];
```

### 直接设置 `UITextField` 的格式化显示文本

如果你想把原始值直接放进输入框，并立刻显示成格式化结果，可以这样用：

```objc
[self.cardTextField yd_setText:@"8888888888888888"
                 withFormatter:self.cardFormatter];
```

### 手动赋值 `textField.text` 后刷新格式

如果文本是代码里直接赋值的，可以这样补一次格式化：

```objc
self.cardTextField.text = @"8888888888888888";
[self.cardTextField yd_applyFormattingWithFormatter:self.cardFormatter];
```

## 对外 API

- `YDInputFormatter`
  业务层直接使用的高层格式化对象，既可处理输入编辑，也可做展示格式化。
- `YDInputFormatterConfig`
  存储分组规则、分隔符、最大长度和字符过滤规则。
- `YDInputFormatterResult`
  返回格式化后的文本、原始文本以及计算出的光标偏移。
- `UITextField+YDInputFormatter`
  同时支持自动接管 delegate、业务 delegate 手动格式化、直接设置格式化显示文本，以及手动赋值后的格式化刷新。

## 接入注意事项

- 先设置业务侧的 `delegate`，再调用 `yd_enableFormatter:`。启用后尽量不要再重设
  `textField.delegate`，因为库内部会安装自己的 delegate 包装层，并把回调转发给之前的 delegate。
- 在 `textField:shouldChangeCharactersInRange:replacementString:` 里，外部 delegate
  最好只负责“是否允许输入”的判断，不要再去改 `textField.text`、`selectedTextRange`
  或者再跑一遍自己的格式化逻辑。
- `editingChanged` 监听拿到的是格式化之后的文本。为了避免光标跳动或重复处理，不建议在这些回调里再次重写文本或光标位置。
- 如果你是程序化地直接设置 `textField.text`，通常还需要再补一次格式化，再依赖最终显示结果。
- 中文输入法联想阶段会被刻意跳过格式化，这通常是正确的，但仍建议结合你们实际使用的输入法做真机验证。
- `textField.text` 保存的是带分隔符的展示文本。如果后端需要的是不带 separator 的原始值，需要业务层显式提取或重新计算。
- 这个库更适合银行卡、手机号、身份证、License Key 这类短文本结构化输入，不适合富文本或复杂 Unicode 编辑场景。

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
