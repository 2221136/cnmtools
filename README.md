# CNM工具箱 🛠️

一个基于Flutter开发的跨平台AI工具箱应用，集成了多种实用的AI工具和功能。

## ✨ 功能特性

### 已实现功能

1. **AI资讯** 📰
   - 获取最新的AI行业资讯和动态

2. **AI识图** 🖼️
   - 智能图片识别和分析

3. **AI图片鉴定** 🔍
   - 鉴定图片是否由AI生成

4. **AI翻译** 🌐
   - 多语言智能翻译

5. **AI对话** 💬
   - 智能对话助手

6. **SBTI人格测试** 🧠
   - 30道题目，15个维度
   - 27种人格类型分析
   - 纯Flutter实现，无需WebView

7. **AI字体设计** ✍️
   - 输入文字生成艺术字体
   - 支持保存到本地相册

8. **抖音解析** 📱
   - 解析抖音视频获取无水印下载链接
   - 支持视频预览和保存

9. **哔哩哔哩解析** 🎬
   - 解析B站视频获取下载链接
   - 显示详细的视频信息和数据统计

10. **壁纸查找** 🖼️
    - 随机获取高质量壁纸
    - 支持关键词搜索
    - 支持保存到相册

## 🚀 技术栈

- **框架**: Flutter 3.5.0
- **语言**: Dart
- **支持平台**: Android, iOS, Web, Windows, macOS, Linux
- **主要依赖**:
  - http - 网络请求
  - url_launcher - URL启动
  - shared_preferences - 本地存储
  - image_picker - 图片选择
  - device_preview - 设备预览
  - video_player - 视频播放
  - chewie - 视频播放器UI
  - dio - 高级网络请求
  - image_gallery_saver - 图片/视频保存
  - permission_handler - 权限管理
  - path_provider - 路径获取

## 📦 安装和运行

### 前置要求

- Flutter SDK 3.5.0 或更高版本
- Dart SDK
- Android Studio / VS Code
- 对应平台的开发环境配置

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/2221136/cnmtools.git
cd cnmtools/cnmtools
```

2. 获取依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

4. 构建APK（Android）
```bash
flutter build apk --release
```

## 🤖 GitHub Actions 自动构建

本项目配置了GitHub Actions自动构建Android APK。

### 触发条件

- 推送到 `main` 或 `master` 分支
- 创建Pull Request到 `main` 或 `master` 分支
- 手动触发（workflow_dispatch）

### 构建产物

构建完成后，可以在GitHub Actions的Artifacts中下载APK文件：

1. 进入仓库的 **Actions** 标签页
2. 选择最新的构建任务
3. 在页面底部的 **Artifacts** 区域下载 `app-release`
4. 解压后即可获得 `app-release.apk`

### 构建配置

- **运行环境**: Ubuntu Latest
- **Java版本**: 17 (Zulu)
- **Flutter版本**: 3.27.3 (Stable)
- **构建类型**: Release APK
- **保留时间**: 30天

## 📱 权限说明

### Android权限

- `INTERNET` - 网络访问
- `READ_EXTERNAL_STORAGE` - 读取存储（Android 12及以下）
- `WRITE_EXTERNAL_STORAGE` - 写入存储（Android 12及以下）
- `READ_MEDIA_IMAGES` - 读取图片（Android 13+）
- `READ_MEDIA_VIDEO` - 读取视频（Android 13+）

## 🔧 配置说明

### API Key配置

部分功能需要配置API Key：

1. 打开应用
2. 进入"设置"页面
3. 输入API Key
4. 保存配置

## 📝 开发说明

### 项目结构

```
cnmtools/
├── lib/
│   ├── data/              # 数据文件
│   ├── models/            # 数据模型
│   ├── pages/             # 页面UI
│   ├── services/          # 服务层
│   ├── utils/             # 工具类
│   └── main.dart          # 入口文件
├── assets/                # 资源文件
│   └── personality_test/  # 人格测试图片
├── android/               # Android平台配置
├── ios/                   # iOS平台配置
├── web/                   # Web平台配置
├── windows/               # Windows平台配置
├── macos/                 # macOS平台配置
└── linux/                 # Linux平台配置
```

### 添加新功能

1. 在 `lib/models/` 创建数据模型
2. 在 `lib/services/` 添加API服务
3. 在 `lib/pages/` 创建UI页面
4. 在 `lib/pages/home_page.dart` 添加入口

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📄 许可证

本项目采用MIT许可证。

## 👤 作者

- GitHub: [@2221136](https://github.com/2221136)
- Email: 2217432581@qq.com

## 🙏 致谢

感谢所有使用的开源项目和API服务提供商。

---

⭐ 如果这个项目对你有帮助，请给个Star支持一下！
