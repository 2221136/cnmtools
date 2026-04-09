import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../models/translate_model.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final TextEditingController _inputController = TextEditingController();
  String? _translatedText;
  bool _isLoading = false;
  String? _errorMessage;
  
  String _sourceLang = 'auto';
  String _targetLang = 'zh';

  final Map<String, String> _languages = {
    'auto': '自动检测',
    'zh': '中文',
    'en': '英语',
    'ja': '日语',
    'ko': '韩语',
    'fr': '法语',
    'de': '德语',
    'es': '西班牙语',
    'ru': '俄语',
    'ar': '阿拉伯语',
  };

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    final text = _inputController.text.trim();
    
    if (text.isEmpty) {
      _showError('请输入要翻译的文字');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ApiService.translate(
        text: text,
        sourceLang: _sourceLang == 'auto' ? null : _sourceLang,
        targetLang: _targetLang,
      );

      setState(() {
        _isLoading = false;
        if (result.code == 200) {
          _translatedText = result.data;
        } else {
          _errorMessage = result.message;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  void _swapLanguages() {
    if (_sourceLang == 'auto') return;
    
    setState(() {
      final temp = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = temp;
      
      // 交换文本
      if (_translatedText != null && _translatedText!.isNotEmpty) {
        final tempText = _inputController.text;
        _inputController.text = _translatedText!;
        _translatedText = tempText;
      }
    });
  }

  void _copyResult() {
    if (_translatedText != null && _translatedText!.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _translatedText!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已复制到剪贴板')),
      );
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
        title: const Text('AI智能翻译'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 语言选择器
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _sourceLang,
                        decoration: const InputDecoration(
                          labelText: '源语言',
                          border: OutlineInputBorder(),
                        ),
                        items: _languages.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _sourceLang = value);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      onPressed: _swapLanguages,
                      tooltip: '交换语言',
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _targetLang,
                        decoration: const InputDecoration(
                          labelText: '目标语言',
                          border: OutlineInputBorder(),
                        ),
                        items: _languages.entries
                            .where((entry) => entry.key != 'auto')
                            .map((entry) {
                          return DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _targetLang = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 输入框
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '输入文本',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _inputController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: '请输入要翻译的文字...',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _translatedText = null;
                          _errorMessage = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 翻译按钮
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _translate,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.translate),
              label: Text(_isLoading ? '翻译中...' : '开始翻译'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // 翻译结果
            if (_translatedText != null || _errorMessage != null)
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
                            _errorMessage != null ? Icons.error : Icons.check_circle,
                            color: _errorMessage != null ? Colors.red : Colors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _errorMessage != null ? '翻译失败' : '翻译结果',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_translatedText != null) ...[
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: _copyResult,
                              tooltip: '复制',
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _errorMessage ?? _translatedText ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: _errorMessage != null ? Colors.red : Colors.black87,
                          height: 1.5,
                        ),
                      ),
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
                    _buildInfoItem('1. 选择源语言和目标语言'),
                    _buildInfoItem('2. 输入要翻译的文字'),
                    _buildInfoItem('3. 点击"开始翻译"按钮'),
                    _buildInfoItem('4. 查看翻译结果'),
                    _buildInfoItem('5. 可点击复制按钮复制结果'),
                    const SizedBox(height: 8),
                    Text(
                      '提示：支持多种语言互译，使用AI大模型提供高质量翻译',
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
