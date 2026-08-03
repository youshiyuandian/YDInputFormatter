# YDInputFormatter 0.1.1 Release Checklist

这是一份面向当前仓库的 `0.1.1` 发版流程清单，按顺序执行即可。

## 1. 发版前确认

- [ ] 确认 `0.1.1` 的变更范围已经收敛，只包含这次准备发布的内容
- [ ] 确认本地工作区干净，避免把无关改动一起发出去
- [ ] 确认本次版本号就是 `0.1.1`

检查工作区：

```bash
git status --short --branch
```

## 2. 更新版本相关文件

需要同步检查这些文件里的版本号：

- [ ] [YDInputFormatter.podspec](/Users/lzx/Desktop/YDInputFormatter/YDInputFormatter.podspec)
- [ ] [README.md](/Users/lzx/Desktop/YDInputFormatter/README.md)
- [ ] [README.zh-CN.md](/Users/lzx/Desktop/YDInputFormatter/README.zh-CN.md)
- [ ] 新建或更新 `RELEASE_NOTES_0.1.1.md`

当前仓库里 `0.1.0` 出现的位置可作为替换参考：

- `YDInputFormatter.podspec`
- `README.md`
- `README.zh-CN.md`
- `RELEASE_NOTES_0.1.0.md`

推荐检查命令：

```bash
rg -n "0\.1\.0|0\.1\.1"
```

## 3. 本地验证

先跑工程构建：

```bash
xcodebuild -project YDInputFormatter.xcodeproj -scheme YDInputFormatter -configuration Release build
```

再跑 podspec 校验：

```bash
pod lib lint YDInputFormatter.podspec --allow-warnings
```

如果当前机器仍然遇到 `CoreSimulatorService` 相关问题，再退回到和 `0.1.0`
相同的兜底命令：

```bash
pod lib lint YDInputFormatter.podspec --allow-warnings --skip-tests --skip-import-validation
```

## 4. 提交代码

- [ ] 确认本次改动只包含 `0.1.1` 需要发布的内容
- [ ] 提交一个清晰的 release commit

示例：

```bash
git add .
git commit -m "release: 0.1.1"
```

## 5. 打 tag

- [ ] 创建 `0.1.1` tag

```bash
git tag 0.1.1
```

## 6. 推送到 GitHub

如果后续你已经把 SSH config 配好了，可以直接推：

```bash
git push origin main
git push origin 0.1.1
```

如果仍沿用这台机器当前的独立 key 方式，使用：

```bash
git -c core.sshCommand='ssh -i /Users/lzx/.ssh/id_ed25519_youshiyuandian -o IdentitiesOnly=yes' push origin main
git -c core.sshCommand='ssh -i /Users/lzx/.ssh/id_ed25519_youshiyuandian -o IdentitiesOnly=yes' push origin 0.1.1
```

## 7. 发布 CocoaPods

优先尝试正常发布：

```bash
pod trunk push YDInputFormatter.podspec --allow-warnings
```

如果当前机器还是被本地模拟器环境影响，沿用 `0.1.0` 的发布命令：

```bash
pod trunk push YDInputFormatter.podspec --allow-warnings --skip-tests --skip-import-validation
```

发布后核对：

```bash
pod trunk info YDInputFormatter
```

## 8. 发布 GitHub Release

- [ ] 从 `RELEASE_NOTES_0.1.0.md` 复制一份为 `RELEASE_NOTES_0.1.1.md`
- [ ] 把版本号、变更说明、安装示例更新成 `0.1.1`
- [ ] 创建或更新 GitHub Release

示例：

```bash
gh release create 0.1.1 --repo youshiyuandian/YDInputFormatter --title "0.1.1" --notes-file RELEASE_NOTES_0.1.1.md
```

如果 Release 已经存在，用：

```bash
gh release edit 0.1.1 --repo youshiyuandian/YDInputFormatter --notes-file RELEASE_NOTES_0.1.1.md
```

## 9. 发版后检查

- [ ] 打开 GitHub 仓库确认 `main`、`0.1.1` tag、Release 都已存在
- [ ] 打开 CocoaPods 页面确认版本已显示
- [ ] 用 GitHub tag 方式做一次安装验证
- [ ] 等待 CocoaPods CDN 同步后，再验证 `pod 'YDInputFormatter', '0.1.1'`

GitHub tag 安装验证：

```ruby
pod 'YDInputFormatter', :git => 'https://github.com/youshiyuandian/YDInputFormatter.git', :tag => '0.1.1'
```

## 10. 已知注意点

- `0.1.0` 发布后，`pod trunk info` 先可见，但 CocoaPods CDN 搜索和安装有一段同步延迟
- 所以下次发 `0.1.1` 时，如果刚发完就 `pod install` 失败，不一定是 podspec 有问题，先用 `pod trunk info YDInputFormatter` 核对，再等待 CDN 同步
