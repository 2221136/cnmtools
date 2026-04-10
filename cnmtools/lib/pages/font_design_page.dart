import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../models/font_design_model.dart';

class FontDesignPage extends StatefulWidget {
  const FontDesignPage({super.key});

  @override
  State<FontDesignPage> createState() => _FontDesignPageState();
}

class _FontDesignPageState extends State<FontDesignPage> {
  final TextEditingController _textController = TextEditingController();
  FontDesignResult? _result;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _designFont() async {
    final text = _textController.text.trim();
    
    if (text.isEmpty) {
      _showError('请输入要设计的文字');
      return;
    }

    if (text.length > 20) {
      _showError('文字长度不能超过20个字符');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _result = null;
    });

    try {
      final result = await ApiService.designFont(text: text);

      setState(() {
        _isLoading = false;
        if (result.code == 200) {
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveImageToGallery() async {
    if (_result?.imgUrl == null) {
      _showError('没有可保存的图片');
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
              Text('正在保存图片...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      final response = await Dio().get(
        _result!.imgUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageBytes = Uint8List.fromList(response.data);

      bool success = false;
      String message = '';

      if (kIsWeb) {
        message = '图片已开始下载';
        success = true;
      } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        try {
          final directory = await getDownloadsDirectory();
          
          if (directory != null) {
            final fileName = 'font_design_${DateTime.now().millisecondsSinceEpoch}.png';
            final filePath = '${directory.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(imageBytes);
            message = '图片已保存到: $filePath';
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
              message = '需要存储权限才能保存图片';
              success = false;
            }
          }

          if (status.isGranted) {
            final tempDir = await getTemporaryDirectory();
            final fileName = 'font_design_${DateTime.now().millisecondsSinceEpoch}.png';
            final filePath = '${tempDir.path}/$fileName';
            final file = File(filePath);
            await file.writeAsBytes(imageBytes);
            
            await Gal.putImage(filePath);
            
            try {
              await file.delete();
            } catch (e) {
              // Ignore cleanup errors
            }
            
            message = '图片已保存到相册';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI字体设计'),
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
                        Icon(Icons.text_fields, color: Colors.indigo[700]),
                        const SizedBox(width: 8),
                        const Text(
                          '输入文字',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: '输入要设计的文字（最多20字）',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.edit),
                      ),
                      maxLength: 20,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading || _textController.text.trim().isEmpty
                          ? null
                          : _designFont,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_awesome),
                      label: Text(_isLoading ? '设计中...' : '开始设计'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.indigo,
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

            if (_result != null) ...[
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
                        _result!.imgUrl,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
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
                            '设计完成！',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _saveImageToGallery,
                            icon: const Icon(Icons.save_alt),
                            label: const Text('保存到相册'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
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
                        Icon(Icons.info_outline, color: Colors.blue[700]),
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
                    _buildInfoItem('1. 输入要设计的文字（最多20个字符）'),
                    _buildInfoItem('2. 点击"开始设计"按钮'),
                    _buildInfoItem('3. 等待AI生成艺术字体'),
                    _buildInfoItem('4. 保存生成的图片到相册'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
