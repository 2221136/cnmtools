# GitHub Actions 自动构建指南 🚀

## 📋 概述

本项目已配置GitHub Actions自动构建Android APK，每次推送代码到main分支时会自动触发构建。

## 🔧 配置文件位置

`.github/workflows/build.yml`

## ⚡ 触发方式

### 1. 自动触发
- 推送代码到 `main` 或 `master` 分支
- 创建Pull Request到 `main` 或 `master` 分支

### 2. 手动触发
1. 进入GitHub仓库页面
2. 点击 **Actions** 标签
3. 选择 **Build Android APK** workflow
4. 点击右侧的 **Run workflow** 按钮
5. 选择分支（默认main）
6. 点击绿色的 **Run workflow** 按钮

## 📦 下载构建产物

### 方法一：从Actions页面下载

1. 进入仓库的 **Actions** 标签页
   ```
   https://github.com/2221136/cnmtools/actions
   ```

2. 点击最新的构建任务（绿色✓表示成功）

3. 滚动到页面底部，找到 **Artifacts** 区域

4. 点击 **app-release** 下载APK压缩包

5. 解压后得到 `app-release.apk`

### 方法二：直接链接（需要登录GitHub）

```
https://github.com/2221136/cnmtools/actions
```

## 🔍 查看构建日志

1. 进入 **Actions** 标签页
2. 点击任意构建任务
3. 点击左侧的 **build** 查看详细日志
4. 展开各个步骤查看具体输出

## ⏱️ 构建时间

通常需要 **5-10分钟**，具体取决于：
- GitHub Actions服务器负载
- 依赖下载速度
- 代码编译复杂度

## 📊 构建环境

- **操作系统**: Ubuntu Latest
- **Java版本**: 17 (Zulu Distribution)
- **Flutter版本**: 3.27.3 (Stable Channel)
- **构建类型**: Release APK
- **保留时间**: 30天

## 🛠️ 构建步骤

1. **Checkout code** - 检出代码
2. **Setup Java** - 配置Java环境
3. **Setup Flutter** - 配置Flutter环境
4. **Get dependencies** - 获取项目依赖
5. **Build APK** - 构建Release APK
6. **Upload APK** - 上传构建产物

## ❌ 常见问题

### 构建失败怎么办？

1. **查看错误日志**
   - 点击失败的构建任务
   - 查看红色❌的步骤
   - 展开查看详细错误信息

2. **常见错误及解决方案**

   **依赖问题**
   ```
   错误: Package not found
   解决: 检查pubspec.yaml中的依赖版本
   ```

   **编译错误**
   ```
   错误: Compilation failed
   解决: 本地运行flutter analyze检查代码错误
   ```

   **权限问题**
   ```
   错误: Permission denied
   解决: 检查AndroidManifest.xml权限配置
   ```

### APK下载链接过期？

- Artifacts保留时间为30天
- 过期后需要重新触发构建
- 建议及时下载并备份重要版本

### 如何修改Flutter版本？

编辑 `.github/workflows/build.yml`:

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.27.3'  # 修改这里
    channel: 'stable'
```

### 如何修改Java版本？

编辑 `.github/workflows/build.yml`:

```yaml
- name: Setup Java
  uses: actions/setup-java@v4
  with:
    distribution: 'zulu'
    java-version: '17'  # 修改这里
```

## 🎯 最佳实践

1. **提交前本地测试**
   ```bash
   flutter analyze
   flutter test
   flutter build apk --release
   ```

2. **使用语义化版本号**
   - 在pubspec.yaml中更新version
   - 使用git tag标记版本

3. **编写清晰的commit信息**
   ```bash
   git commit -m "feat: 添加新功能"
   git commit -m "fix: 修复bug"
   git commit -m "docs: 更新文档"
   ```

4. **定期清理旧的Artifacts**
   - 进入Settings > Actions > General
   - 设置Artifact保留策略

## 📱 安装APK到手机

### Android手机安装步骤

1. 下载并解压 `app-release.zip`
2. 将 `app-release.apk` 传输到手机
3. 在手机上找到APK文件
4. 点击安装（可能需要允许"未知来源"）
5. 安装完成后打开应用

### 启用"未知来源"安装

**Android 8.0+**
1. 设置 > 应用和通知 > 特殊应用权限
2. 安装未知应用
3. 选择文件管理器
4. 允许来自此来源

**Android 7.0及以下**
1. 设置 > 安全
2. 勾选"未知来源"

## 🔐 安全说明

- APK未签名，仅用于测试
- 生产环境需要配置签名密钥
- 不要在公开仓库中提交密钥文件

## 📞 获取帮助

如果遇到问题：

1. 查看[GitHub Actions文档](https://docs.github.com/actions)
2. 查看[Flutter CI/CD文档](https://docs.flutter.dev/deployment/cd)
3. 在仓库中提交Issue
4. 联系作者: 2217432581@qq.com

---

💡 **提示**: 首次推送后，GitHub Actions会自动运行，请耐心等待构建完成！
