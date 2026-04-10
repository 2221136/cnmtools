import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show Uint8List;
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/wallpaper_model.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  final TextEditingController _searchController = TextEditingController();
  WallpaperResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWallpaper();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWallpaper({String? keyword}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.getRandomWallpaper(keyword: keyword);

      setState(() {
        _isLoading = false;
        if (result.success && result.data != null) {
          _result = result;
        } else {
          _errorMessage = '获取壁纸失败';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _searchWallpaper() {
    final keyword = _searchController.text.trim();
    _loadWallpaper(keyword: keyword.isEmpty ? null : keyword);
  }

  Future<void> _saveWallpaper() async {
    if (_result?.data?.imageUrl == null) {
      _showError('没有可保存的壁纸');
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
              Text('正在保存壁纸...'),
            ],
          ),
          duration: Duration(minutes: 5),
        ),
      );

      bool success = false;
      String message = '';

      if (kIsWeb) {
        message = '壁纸已开始下载';
        success = true;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        try {
          final response = await Dio().get(
            _result!.data!.imageUrl,
            options: Options(responseType: ResponseType.bytes),
          );

          final imageBytes = Uint8List.fromList(response.data);
          final directory = await getDownloadsDirectory();

          if (directory != null) {
            final fileName = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(imageBytes);
            message = '壁纸已保存到: $filePath';
            success = true;
          } else {
            message = '无法获取下载目录';
          }
        } catch (e) {
          message = '保存失败: ${e.toString()}';
        }
      } else {
        try {
          // Android 13+ 使用photos权限，之前版本使用storage权限
          Permission permission = Permission.photos;
          if (Platform.isAndroid) {
            final androidInfo = await DeviceInfoPlugin().androidInfo;
            if (androidInfo.version.sdkInt <= 32) {
              permission = Permission.storage;
            }
          }

          var status = await permission.status;
          if (!status.isGranted) {
            status = await permission.request();
            if (!status.isGranted) {
              message = '需要存储权限才能保存壁纸';
              success = false;
            }
          }

          if (status.isGranted) {
            final response = await Dio().get(
              _result!.data!.imageUrl,
              options: Options(responseType: ResponseType.bytes),
            );

            final imageBytes = Uint8List.fromList(response.data);
            
            final tempDir = await getTemporaryDirectory();
            final fileName = 'wallpaper_${DateTime.now().millisecondsSinceEpoch}.jpg';
            final filePath = '${tempDir.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(imageBytes);
            
            await Gal.putImage(filePath);
            
            try {
              await file.delete();
            } catch (e) {
              // Ignore cleanup errors
            }
            
            message = '壁纸已保存到相册';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('壁纸查找'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _loadWallpaper,
            tooltip: '换一张',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在加载壁纸...'),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadWallpaper,
                        icon: const Icon(Icons.refresh),
                        label: const Text('重试'),
                      ),
                    ],
                  ),
                )
              : _result?.data != null
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 搜索框
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: const InputDecoration(
                                          hintText: '输入关键词搜索壁纸（如：风景、动漫）',
                                          border: InputBorder.none,
                                          prefixIcon: Icon(Icons.search),
                                        ),
                                        onSubmitted: (_) => _searchWallpaper(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _loadWallpaper();
                                      },
                                      tooltip: '清除',
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: _isLoading ? null : _searchWallpaper,
                                      icon: const Icon(Icons.search),
                                      label: const Text('搜索'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // 壁纸图片
                          Hero(
                            tag: 'wallpaper_${_result!.data!.id}',
                            child: Image.network(
                              _result!.data!.imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 400,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 400,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(Icons.error, size: 48),
                                  ),
                                );
                              },
                            ),
                          ),

                          // 壁纸信息
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Icon(Icons.image, color: Colors.teal[700]),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '壁纸信息',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        _buildInfoRow('分类', _result!.data!.msg),
                                        _buildInfoRow('来源', _result!.data!.source),
                                        _buildInfoRow(
                                          '尺寸',
                                          '${_result!.data!.width} × ${_result!.data!.height}',
                                        ),
                                        _buildInfoRow('ID', _result!.data!.id.toString()),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // 操作按钮
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _saveWallpaper,
                                        icon: const Icon(Icons.save_alt),
                                        label: const Text('保存壁纸'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          final keyword = _searchController.text.trim();
                                          _loadWallpaper(
                                            keyword: keyword.isEmpty ? null : keyword,
                                          );
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('换一张'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('暂无数据'),
                    ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
