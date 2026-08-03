Pod::Spec.new do |s|
  s.name             = 'YDInputFormatter'
  s.version          = '0.1.1'
  s.summary          = 'UITextField input formatter with grouping and caret restoration.'
  s.description      = <<-DESC
  YDInputFormatter is an Objective-C input formatting component for UITextField.
  It supports grouped formatting, custom separators, max length limiting,
  caret restoration, paste handling, and marked text compatibility.
  DESC
  s.homepage         = 'https://github.com/youshiyuandian/YDInputFormatter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lizuxi' => 'ios_lizuxi@163.com' }
  s.source           = { :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => s.version.to_s }

  s.platform         = :ios, '13.0'
  s.requires_arc     = true
  s.frameworks       = 'UIKit'
  s.module_name      = 'YDInputFormatter'
  s.header_mappings_dir = 'YDInputFormatter/Formatter'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.source_files = 'YDInputFormatter/Formatter/**/*.{h,m}'
  s.public_header_files = [
    'YDInputFormatter/Formatter/Core/YDInputFormatter.h',
    'YDInputFormatter/Formatter/Core/YDInputFormatterConfig.h',
    'YDInputFormatter/Formatter/Core/YDInputFormatterResult.h',
    'YDInputFormatter/Formatter/UIKit/UITextField+YDInputFormatter.h'
  ]
  s.private_header_files = 'YDInputFormatter/Formatter/Core/YDInputFormatterEngine.h'
end
