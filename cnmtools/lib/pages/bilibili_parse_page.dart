import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/bilibili_model.dart';

class BilibiliParsePage extends StatefulWidget {
  const BilibiliParsePage({super.key});

  @override
  State<BilibiliParsePage> createState() => _BilibiliParsePageState();
}

class _BilibiliParsePageState extends State<BilibiliParsePage> {
  final TextEditingController _urlController = TextEditingController();
  BilibiliResult? _result;
  bool _isLoading = false;
  String? _errorMessage;
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isVideoLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _disposeVideoPlayer();
    super.dispose();
  }

  void _disposeVideoPlayer() {
    _chewieController?.dispose();
    _videoController?.dispose();
    _chewieController = null;
    _videoController = null;
  }

  Future<void> _parseVideo() async {
    final url = _urlController.text.trim();
    
    if (url.isEmpty) {
      _showError('请输入哔哩哔哩视频链接');
      return;
    }

    if (!url.contains('bilibili.com') && !url.contains('b23.tv')) {
      _showError('请输入有效的哔哩哔哩视频链接');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    _disposeVideoPlayer();

    try {
      final result = await ApiService.parseBilibili(url);

      setState(() {
        _isLoading = false;
        if (result.code == 200 && result.data != null) {
          _result = result;
        } else {
          _errorMessage = result.msg;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _initializeVideoPlayer() async {
    if (_result?.data?.url == null) return;

    setState(() {
      _isVideoLoading = true;
    });

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_result!.data!.url),
      );

      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  '视频加载失败\n$errorMessage',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        },
      );

      setState(() {
        _isVideoLoading = false;
      });
    } catch (e) {
      setState(() {
        _isVideoLoading = false;
      });
      _showError('视频加载失败: ${e.toString()}');
    }
  }

  Future<void> _saveVideoToGallery() async {
    if (_result?.data?.url == null) {
      _showError('没有可保存的视频');
      return;
    }

    try {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('正在下载视频...'),
            ],
          ),
          duration: Duration(minutes: 5),
        ),
      );

      bool success = false;
      String message = '';

      if (kIsWeb) {
        await _openUrl(_result!.data!.url);
        message = '视频已开始下载';
        success = true;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        try {
          final response = await Dio().get(
            _result!.data!.url,
            options: Options(responseType: ResponseType.bytes),
          );

          final videoBytes = Uint8List.fromList(response.data);
          final directory = await getDownloadsDirectory();
          
          if (directory != null) {
            final fileName = 'bilibili_${DateTime.now().millisecondsSinceEpoch}.mp4';
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(videoBytes);
            message = '视频已保存到: $filePath';
            success = true;
          } else {
            message = '无法获取下载目录';
          }
        } catch (e) {
          message = '保存失败: ${e.toString()}';
        }
      } else {
        try {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            status = await Permission.storage.request();
            if (!status.isGranted) {
              message = '需要存储权限才能保存视频';
              success = false;
            }
          }

          if (status.isGranted) {
            final tempDir = await getTemporaryDirectory();
            final fileName = 'bilibili_${DateTime.now().millisecondsSinceEpoch}.mp4';
            final filePath = '${tempDir.path}/$fileName';
            
            await Dio().download(
              _result!.data!.url,
              filePath,
            );

            await Gal.putVideo(filePath);
            
            try {
              await File(filePath).delete();
            } catch (e) {
              // Ignore cleanup errors
            }
            
            message = '视频已保存到相册';
            success = true;
          }
        } catch (e) {
          message = '保存失败: ${e.toString()}';
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _showError(message);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _showError('保存失败: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _copyText(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label已复制到剪贴板')),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showError('无法打开链接');
    }
  }

  String _formatNumber(int number) {
    if (number >= 10000) {
      return '${(number / 10000).toStringAsFixed(1)}万';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('哔哩哔哩解析'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.video_library, color: Colors.cyan[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '输入哔哩哔哩链接',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: '粘贴哔哩哔哩视频分享链接',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_urlController.text.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _urlController.clear();
                                  });
                                },
                              ),
                            IconButton(
                              icon: const Icon(Icons.content_paste),
                              onPressed: () async {
                                final data = await Clipboard.getData('text/plain');
                                if (data != null && data.text != null) {
                                  setState(() {
                                    _urlController.text = data.text!;
                                  });
                                }
                              },
                              tooltip: '粘贴',
                            ),
                          ],
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _parseVideo,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(_isLoading ? '解析中...' : '开始解析'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_errorMessage != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (_result?.data != null) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(_result!.data!.user.userImg),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _result!.data!.user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'UP主: ${_result!.data!.user.name}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () => _copyText(_result!.data!.user.name, 'UP主名称'),
                        tooltip: '复制UP主名称',
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        _result!.data!.cover,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.error, size: 48),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _result!.data!.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '发布时间: ${_result!.data!.pubdate}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.play_arrow,
                                _formatNumber(_result!.data!.stats.view),
                                '播放',
                              ),
                              _buildStatItem(
                                Icons.favorite,
                                _formatNumber(_result!.data!.stats.like),
                                '点赞',
                              ),
                              _buildStatItem(
                                Icons.star,
                                _formatNumber(_result!.data!.stats.favorite),
                                '收藏',
                              ),
                              _buildStatItem(
                                Icons.share,
                                _formatNumber(_result!.data!.stats.share),
                                '分享',
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatItem(
                                Icons.monetization_on,
                                _formatNumber(_result!.data!.stats.coin),
                                '投币',
                              ),
                              _buildStatItem(
                                Icons.comment,
                                _formatNumber(_result!.data!.stats.reply),
                                '评论',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_chewieController != null) ...[
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Chewie(controller: _chewieController!),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (_isVideoLoading)
                            Container(
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16),
                                    Text('正在加载视频...'),
                                  ],
                                ),
                              ),
                            ),
                          if (_isVideoLoading) const SizedBox(height: 16),
                          Row(
                            children: [
                              if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _chewieController == null && !_isVideoLoading
                                        ? _initializeVideoPlayer
                                        : null,
                                    icon: const Icon(Icons.play_circle_outline),
                                    label: const Text('预览视频'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(0, 48),
                                    ),
                                  ),
                                ),
                              if (!Platform.isWindows && !Platform.isLinux && !Platform.isMacOS)
                                const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _saveVideoToGallery,
                                  icon: const Icon(Icons.save_alt),
                                  label: const Text('保存视频'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(0, 48),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () => _openUrl(_result!.data!.url),
                            icon: const Icon(Icons.download),
                            label: const Text('浏览器下载'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: () => _copyText(_result!.data!.url, '视频链接'),
                            icon: const Icon(Icons.copy),
                            label: const Text('复制视频链接'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.cyan[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '使用说明',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem('1. 打开哔哩哔哩APP，找到想要下载的视频'),
                    _buildInfoItem('2. 点击分享按钮，选择"复制链接"'),
                    _buildInfoItem('3. 返回本应用，粘贴链接'),
                    _buildInfoItem('4. 点击"开始解析"按钮'),
                    _buildInfoItem('5. 查看视频信息并下载视频'),
                    const SizedBox(height: 8),
                    Text(
                      '提示：解析后的视频可直接下载保存',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.cyan[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
