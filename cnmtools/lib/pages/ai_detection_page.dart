import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/ai_detection_model.dart';

class AiDetectionPage extends StatefulWidget {
  const AiDetectionPage({super.key});

  @override
  State<AiDetectionPage> createState() => _AiDetectionPageState();
}

class _AiDetectionPageState extends State<AiDetectionPage> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _urlController = TextEditingController();
  
  File? _selectedImage;
  String? _imageUrl;
  AiDetectionData? _detectionResult;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null;
          _detectionResult = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      _showError('选择图片失败: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _imageUrl = null;
          _detectionResult = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      _showError('拍照失败: $e');
    }
  }

  void _useImageUrl() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _showError('请输入图片链接');
      return;
    }

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      _showError('请输入有效的图片链接（以http://或https://开头）');
      return;
    }

    setState(() {
      _imageUrl = url;
      _selectedImage = null;
      _detectionResult = null;
      _errorMessage = null;
    });

    Navigator.pop(context);
  }

  Future<void> _detectImage() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      late AiDetectionResult result;

      if (_imageUrl != null) {
        result = await ApiService.detectAiImage(_imageUrl!);
      } else if (_selectedImage != null) {
        result = await ApiService.detectAiImageFile(_selectedImage!.path);
      } else {
        _showError('请先选择图片或输入图片链接');
        setState(() => _isLoading = false);
        return;
      }

      setState(() {
        _isLoading = false;
        if (result.code == 200 && result.data != null) {
          _detectionResult = result.data;
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
    setState(() {
      _errorMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('使用图片链接'),
              onTap: () {
                Navigator.pop(context);
                _showUrlInputDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('取消'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showUrlInputDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('输入图片链接'),
        content: TextField(
          controller: _urlController,
          decoration: const InputDecoration(
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: _useImageUrl,
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI图片鉴定'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 图片预览区域
            Card(
              elevation: 4,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : _imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              _imageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error, size: 48, color: Colors.red),
                                      SizedBox(height: 8),
                                      Text('图片加载失败'),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '点击下方按钮选择图片',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 16),

            // 选择图片按钮
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('选择图片'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 12),

            // 检测按钮
            ElevatedButton.icon(
              onPressed: (_selectedImage != null || _imageUrl != null) && !_isLoading
                  ? _detectImage
                  : null,
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
              label: Text(_isLoading ? '检测中...' : '开始检测'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 检测结果区域
            if (_detectionResult != null || _errorMessage != null)
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _errorMessage != null 
                                ? Icons.error 
                                : (_detectionResult!.flagged ? Icons.warning : Icons.check_circle),
                            color: _errorMessage != null 
                                ? Colors.red 
                                : (_detectionResult!.flagged ? Colors.orange : Colors.green),
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _errorMessage != null 
                                      ? '检测失败' 
                                      : (_detectionResult!.flagged ? 'AI生成图片' : '真实图片'),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_detectionResult != null)
                                  Text(
                                    'AI指数: ${(_detectionResult!.categoryScores.aigc * 100).toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ],
                      if (_detectionResult != null) ...[
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),
                        _buildResultItem(
                          '检测结果',
                          _detectionResult!.flagged ? '疑似AI生成' : '真实拍摄/绘制',
                          _detectionResult!.flagged ? Colors.orange : Colors.green,
                        ),
                        const SizedBox(height: 8),
                        _buildResultItem(
                          'AI生成概率',
                          '${(_detectionResult!.categoryScores.aigc * 100).toStringAsFixed(2)}%',
                          _getScoreColor(_detectionResult!.categoryScores.aigc),
                        ),
                        const SizedBox(height: 8),
                        _buildResultItem(
                          '真实概率',
                          '${((1 - _detectionResult!.categoryScores.aigc) * 100).toStringAsFixed(2)}%',
                          _getScoreColor(1 - _detectionResult!.categoryScores.aigc),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            // 使用说明
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
                    _buildInfoItem('1. 选择需要检测的图片'),
                    _buildInfoItem('2. 点击"开始检测"按钮'),
                    _buildInfoItem('3. 查看AI生成概率和检测结果'),
                    _buildInfoItem('4. AI指数越高，越可能是AI生成'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 0.7) return Colors.red;
    if (score >= 0.4) return Colors.orange;
    return Colors.green;
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
