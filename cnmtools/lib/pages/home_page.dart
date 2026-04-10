import 'package:flutter/material.dart';
import 'news_page.dart';
import 'image_recognition_page.dart';
import 'ai_detection_page.dart';
import 'translate_page.dart';
import 'chat_page.dart';
import 'settings_page.dart';
import 'personality_test_page.dart';
import 'font_design_page.dart';
import 'douyin_parse_page.dart';
import 'bilibili_parse_page.dart';
import 'wallpaper_page.dart';
import '../utils/storage_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasApiKey = false;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    final hasKey = await StorageUtil.hasApiKey();
    setState(() {
      _hasApiKey = hasKey;
    });
  }

  Future<void> _navigateToNews() async {
    if (!_hasApiKey) {
      _showApiKeyDialog();
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NewsPage()),
      );
    }
  }

  void _navigateToImageRecognition() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ImageRecognitionPage()),
    );
  }

  void _navigateToAiDetection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiDetectionPage()),
    );
  }

  void _navigateToTranslate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TranslatePage()),
    );
  }

  void _navigateToChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatPage()),
    );
  }

  void _navigateToPersonalityTest() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PersonalityTestPage()),
    );
  }

  void _navigateToFontDesign() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FontDesignPage()),
    );
  }

  void _navigateToDouyinParse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DouyinParsePage()),
    );
  }

  void _navigateToBilibiliParse() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BilibiliParsePage()),
    );
  }

  void _navigateToWallpaper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WallpaperPage()),
    );
  }

  Future<void> _showApiKeyDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('未配置API Key'),
        content: const Text('使用AI资讯功能需要先配置API Key，是否前往设置？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('去设置'),
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      final saved = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
      
      if (saved == true) {
        _checkApiKey();
      }
    }
  }

  Future<void> _navigateToSettings() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
    
    if (result == true) {
      _checkApiKey();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('cnm工具箱'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: '设置',
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: [
          _buildToolCard(
            context,
            icon: Icons.newspaper,
            title: 'AI最新资讯',
            subtitle: '全网AI资讯聚合',
            color: Colors.blue,
            badge: _hasApiKey ? null : '未配置',
            onTap: _navigateToNews,
          ),
          _buildToolCard(
            context,
            icon: Icons.image_search,
            title: 'AI识图',
            subtitle: '图片内容识别',
            color: Colors.purple,
            onTap: _navigateToImageRecognition,
          ),
          _buildToolCard(
            context,
            icon: Icons.verified,
            title: 'AI图片鉴定',
            subtitle: '检测AI生成图片',
            color: Colors.orange,
            onTap: _navigateToAiDetection,
          ),
          _buildToolCard(
            context,
            icon: Icons.translate,
            title: 'AI智能翻译',
            subtitle: '多语言互译',
            color: Colors.green,
            onTap: _navigateToTranslate,
          ),
          _buildToolCard(
            context,
            icon: Icons.chat,
            title: 'AI智能对话',
            subtitle: '讯飞星火大模型',
            color: Colors.teal,
            onTap: _navigateToChat,
          ),
          _buildToolCard(
            context,
            icon: Icons.psychology,
            title: 'SBTI人格测试',
            subtitle: '新一代人格自测',
            color: Colors.deepPurple,
            onTap: _navigateToPersonalityTest,
          ),
          _buildToolCard(
            context,
            icon: Icons.text_fields,
            title: 'AI字体设计',
            subtitle: '艺术字体生成',
            color: Colors.indigo,
            onTap: _navigateToFontDesign,
          ),
          _buildToolCard(
            context,
            icon: Icons.video_library,
            title: '抖音解析',
            subtitle: '无水印视频下载',
            color: Colors.pink,
            onTap: _navigateToDouyinParse,
          ),
          _buildToolCard(
            context,
            icon: Icons.play_circle,
            title: '哔哩哔哩解析',
            subtitle: 'B站视频下载',
            color: Colors.cyan,
            onTap: _navigateToBilibiliParse,
          ),
          _buildToolCard(
            context,
            icon: Icons.wallpaper,
            title: '壁纸查找',
            subtitle: '随机精美壁纸',
            color: Colors.teal,
            onTap: _navigateToWallpaper,
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 36,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badge != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
