# cnm工具箱

一个基于Flutter开发的跨平台工具箱应用，集成了多种实用工具。

## 功能特性

### ✅ 已实现功能

#### 1. AI全网最新资讯
- 实时获取最近24小时内的AI行业资讯
- 支持7大分类浏览：
  - 🤖 模型发布/更新
  - 🛠️ 开发工具/框架
  - 📚 学术研究/论文
  - 💼 公司/商业动态
  - 💡 应用案例/创意
  - 💬 技术问题讨论
  - 🔒 伦理/安全
- 支持下拉刷新
- 点击新闻可跳转到原文链接
- 数据缓存24小时

### 🚧 待开发功能
- 更多实用工具正在规划中...

## 快速开始

### 前置要求
- Flutter SDK 3.11.4 或更高版本
- Dart SDK
- Android Studio / Xcode / VS Code

### 安装步骤

1. 克隆项目
```bash
cd cnmtools
```

2. 安装依赖
```bash
flutter pub get
```

3. 配置API Key
打开 `lib/services/api_service.dart` 文件，将 `YOUR_API_KEY_HERE` 替换为你的实际API Key：

```dart
static const String apiKey = 'YOUR_API_KEY_HERE';
```

> API Key获取方式：访问 https://api.pearktrue.cn/ 注册并获取

4. 运行应用
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 项目结构

```
lib/
├── main.dart                 # 应用入口
├── models/                   # 数据模型
│   └── news_model.dart      # 新闻数据模型
├── services/                 # 服务层
│   └── api_service.dart     # API请求服务
└── pages/                    # 页面
    ├── home_page.dart       # 主页（工具列表）
    └── news_page.dart       # AI资讯页面
```

## 技术栈

- **框架**: Flutter 3.11.4
- **语言**: Dart
- **状态管理**: StatefulWidget
- **网络请求**: http ^1.2.0
- **URL跳转**: url_launcher ^6.2.0
- **图标生成**: flutter_launcher_icons ^0.13.1
- **设备预览**: device_preview ^1.2.0 (仅开发环境)

## 开发工具

### Device Preview - 桌面端模拟移动设备

本项目集成了 Device Preview 插件，允许在桌面端（Windows/macOS/Linux）模拟各种移动设备。

**特性**：
- 🎯 自动启用：仅在桌面平台的开发模式下启用
- 📱 多设备支持：iPhone、Android、iPad等多种设备
- 🔄 横竖屏切换：快速测试不同方向的布局
- 🌓 主题切换：测试亮色/暗色主题
- 📐 自定义尺寸：支持自定义设备尺寸

**使用方法**：
```bash
# 在桌面端运行即可自动启用
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

详细使用说明请查看 `DevicePreview使用说明.md`

## 依赖说明

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0              # HTTP请求
  url_launcher: ^6.2.0      # 打开外部链接

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  flutter_launcher_icons: ^0.13.1  # 应用图标生成
```

## API接口说明

### AI全网最新资讯接口
- **接口地址**: `https://api.pearktrue.cn/api/latest_ai_consultative`
- **请求方式**: GET
- **请求参数**: 
  - `key`: API密钥（必填）
- **返回格式**: JSON
- **缓存策略**: 24小时缓存，首次访问扣费，24小时内不扣费

详细接口文档请查看 `接入文档.md`

## 构建发布

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

### Linux
```bash
flutter build linux --release
```

## 注意事项

1. **API Key配置**: 使用前必须配置有效的API Key
2. **网络权限**: 
   - Android已配置INTERNET权限
   - iOS已配置NSAppTransportSecurity
3. **数据缓存**: API数据缓存24小时，避免频繁请求
4. **链接跳转**: 点击新闻会在外部浏览器打开

## 常见问题

### Q: 无法加载资讯数据？
A: 请检查：
1. 是否配置了正确的API Key
2. 网络连接是否正常
3. API服务是否可用

### Q: 点击新闻无法跳转？
A: 请确保设备已安装浏览器应用

### Q: 如何更换应用图标？
A: 替换根目录的 `logo.png` 文件，然后运行：
```bash
flutter pub run flutter_launcher_icons
```

## 开发计划

- [ ] 添加更多实用工具
- [ ] 支持本地数据缓存
- [ ] 添加主题切换功能
- [ ] 支持多语言
- [ ] 添加用户设置页面

## 许可证

本项目仅供学习和个人使用。

## 联系方式

如有问题或建议，欢迎反馈。
