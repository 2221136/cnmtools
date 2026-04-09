# Device Preview 使用说明

## 功能介绍

Device Preview 是一个强大的Flutter插件，允许你在桌面端（Windows/macOS/Linux）模拟各种移动设备，方便开发和测试。

## 已配置功能

### 自动启用条件
Device Preview 仅在以下条件下自动启用：
- ✅ 运行在桌面平台（Windows、macOS、Linux）
- ✅ 处于开发模式（Debug模式）
- ❌ 发布模式（Release）下自动禁用
- ❌ 移动平台（Android、iOS）不启用

### 配置说明

在 `lib/main.dart` 中已完成配置：

```dart
void main() {
  runApp(
    DevicePreview(
      enabled: !kReleaseMode && (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux),
      builder: (context) => const MyApp(),
    ),
  );
}
```

## 如何使用

### 1. 启动应用

在桌面端运行应用：

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### 2. Device Preview 界面说明

启动后，你会看到一个包含以下功能的界面：

#### 左侧工具栏
- 📱 **设备选择器**: 切换不同的设备型号
  - iPhone 系列（iPhone 15 Pro、iPhone SE等）
  - Android 设备（Pixel、Samsung等）
  - iPad 系列
  - 自定义设备尺寸

#### 顶部工具栏
- 🔄 **旋转设备**: 切换横屏/竖屏
- 📐 **缩放控制**: 调整预览窗口大小
- 🌓 **主题切换**: 切换亮色/暗色模式
- 🌍 **语言切换**: 测试多语言支持
- ⚙️ **设置**: 更多配置选项

#### 右侧面板
- 📊 **设备信息**: 显示当前设备的详细参数
- 🎨 **主题设置**: 自定义主题配置
- 🔧 **辅助功能**: 测试无障碍功能

### 3. 常用操作

#### 切换设备
1. 点击左上角的设备图标
2. 从列表中选择目标设备
3. 应用会自动适配新设备的尺寸

#### 测试横竖屏
1. 点击顶部的旋转图标
2. 或使用快捷键（如果支持）

#### 截图
1. 点击相机图标
2. 截图会保存到系统默认位置

#### 调整缩放
1. 使用缩放滑块
2. 或使用鼠标滚轮（Ctrl + 滚轮）

## 支持的设备列表

### iPhone 系列
- iPhone 15 Pro Max
- iPhone 15 Pro
- iPhone 15
- iPhone 14 Pro Max
- iPhone 14 Pro
- iPhone SE (3rd generation)
- 更多...

### Android 系列
- Google Pixel 8 Pro
- Google Pixel 7
- Samsung Galaxy S23 Ultra
- Samsung Galaxy A54
- 更多...

### 平板系列
- iPad Pro 12.9"
- iPad Pro 11"
- iPad Air
- iPad mini
- 更多...

## 性能优化建议

### 1. 仅在需要时启用
当前配置已自动处理，仅在桌面开发环境启用。

### 2. 发布版本自动禁用
```dart
enabled: !kReleaseMode && (/* 桌面平台判断 */)
```

### 3. 移动端不启用
在真实移动设备上运行时，Device Preview 不会启用，避免性能损耗。

## 快捷键（部分）

- `Ctrl/Cmd + R`: 旋转设备
- `Ctrl/Cmd + S`: 截图
- `Ctrl/Cmd + D`: 切换暗色模式
- `Ctrl/Cmd + L`: 切换语言

## 常见问题

### Q: 为什么在移动设备上看不到 Device Preview？
A: 这是正常的，Device Preview 仅在桌面平台的开发模式下启用。

### Q: 如何禁用 Device Preview？
A: 有两种方式：
1. 临时禁用：在代码中将 `enabled` 设为 `false`
2. 移除依赖：从 `pubspec.yaml` 中删除 `device_preview`

### Q: Device Preview 会影响发布版本吗？
A: 不会，配置中使用了 `!kReleaseMode` 判断，发布版本自动禁用。

### Q: 可以自定义设备吗？
A: 可以，在 Device Preview 界面中选择"Custom"设备，然后设置自定义尺寸。

## 高级配置

### 自定义初始设备

```dart
DevicePreview(
  enabled: /* ... */,
  defaultDevice: Devices.ios.iPhone13,
  builder: (context) => const MyApp(),
)
```

### 自定义可用设备列表

```dart
DevicePreview(
  enabled: /* ... */,
  devices: [
    Devices.ios.iPhone13,
    Devices.android.samsungGalaxyS20,
    Devices.ios.iPad,
  ],
  builder: (context) => const MyApp(),
)
```

### 保存用户设置

Device Preview 会自动保存用户的设备选择、主题等设置，下次启动时恢复。

## 开发建议

1. **多设备测试**: 使用 Device Preview 测试不同屏幕尺寸的适配
2. **响应式设计**: 确保应用在各种设备上都能正常显示
3. **横竖屏适配**: 测试横竖屏切换时的布局变化
4. **主题测试**: 测试亮色和暗色主题的显示效果

## 相关资源

- [Device Preview GitHub](https://github.com/aloisdeniel/flutter_device_preview)
- [Flutter 官方文档](https://flutter.dev)
- [响应式设计指南](https://docs.flutter.dev/ui/layout/responsive)

## 注意事项

1. Device Preview 仅用于开发和测试，不应在生产环境启用
2. 某些硬件相关功能（如相机、传感器）无法在模拟器中完全测试
3. 性能测试应在真实设备上进行
4. Device Preview 增加了一定的性能开销，复杂应用可能会有卡顿

## 总结

Device Preview 是一个非常实用的开发工具，可以大大提高开发效率。通过在桌面端模拟各种移动设备，你可以快速测试应用在不同设备上的表现，而无需频繁切换真实设备。
