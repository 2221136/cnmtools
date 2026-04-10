import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/storage_util.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _apiKeyController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadApiKey() async {
    setState(() => _isLoading = true);
    
    final apiKey = await StorageUtil.getApiKey();
    if (apiKey != null) {
      _apiKeyController.text = apiKey;
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveApiKey() async {
    final apiKey = _apiKeyController.text.trim();
    
    if (apiKey.isEmpty) {
      _showMessage('请输入API Key', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    final success = await StorageUtil.saveApiKey(apiKey);

    setState(() => _isSaving = false);

    if (success) {
      _showMessage('保存成功');
      if (mounted) {
        Navigator.pop(context, true); // 返回true表示已保存
      }
    } else {
      _showMessage('保存失败，请重试', isError: true);
    }
  }

  Future<void> _clearApiKey() async {
    final confirmed = await _showConfirmDialog(
      '确认清除',
      '确定要清除已保存的API Key吗？',
    );

    if (confirmed == true) {
      setState(() => _isSaving = true);
      
      final success = await StorageUtil.removeApiKey();
      
      setState(() => _isSaving = false);

      if (success) {
        _apiKeyController.clear();
        _showMessage('已清除API Key');
      } else {
        _showMessage('清除失败，请重试', isError: true);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('如何获取API Key'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '1. 访问官方网站',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('https://api.pearktrue.cn/'),
              const SizedBox(height: 16),
              const Text(
                '2. 注册账号',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('点击注册按钮，填写相关信息完成注册'),
              const SizedBox(height: 16),
              const Text(
                '3. 获取API Key',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('登录后在个人中心或API管理页面获取你的API Key'),
              const SizedBox(height: 16),
              const Text(
                '4. 复制并粘贴',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('将获取到的API Key复制并粘贴到上方输入框中'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  void _showAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.campaign, color: Colors.orange[700]),
            const SizedBox(width: 8),
            const Text('欢迎使用CNM工具箱'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'CNM工具箱是一款集成多种实用AI工具的跨平台应用，包括：',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 12),
              _buildFeatureItem('🤖 AI资讯、识图、图片鉴定'),
              _buildFeatureItem('🌐 AI翻译、对话助手'),
              _buildFeatureItem('🧠 SBTI人格测试'),
              _buildFeatureItem('✍️ AI字体设计'),
              _buildFeatureItem('📱 抖音/B站视频解析'),
              _buildFeatureItem('🖼️ 壁纸查找'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              const Text(
                '加入官方QQ群，获取更多帮助和更新：',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/qq.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 200,
                              height: 200,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.error, size: 48),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'QQ群号：1073084895',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final url = Uri.parse('https://qm.qq.com/q/LNiZDILtSi');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url, mode: LaunchMode.externalApplication);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('无法打开链接')),
                            );
                          }
                        }
                      },
                      icon: const Icon(Icons.group_add),
                      label: const Text('点击加入QQ群'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 公告卡片
                  Card(
                    elevation: 2,
                    color: Colors.orange[50],
                    child: InkWell(
                      onTap: _showAnnouncementDialog,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.campaign,
                              color: Colors.orange[700],
                              size: 32,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '欢迎使用CNM工具箱',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[900],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '点击查看详情并加入官方QQ群',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.orange[700],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // API Key配置卡片
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.key, color: Colors.blue),
                              const SizedBox(width: 8),
                              const Text(
                                'API Key 配置',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.help_outline),
                                onPressed: _showHelpDialog,
                                tooltip: '如何获取API Key',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _apiKeyController,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                              labelText: 'API Key',
                              hintText: '请输入你的API Key',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.vpn_key),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _obscureText
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureText = !_obscureText;
                                      });
                                    },
                                    tooltip: _obscureText ? '显示' : '隐藏',
                                  ),
                                  if (_apiKeyController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _apiKeyController.clear();
                                      },
                                      tooltip: '清空',
                                    ),
                                ],
                              ),
                            ),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _isSaving ? null : _saveApiKey,
                                  icon: _isSaving
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.save),
                                  label: Text(_isSaving ? '保存中...' : '保存'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _isSaving ? null : _clearApiKey,
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('清除'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 说明信息
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
                                Icons.info_outline,
                                color: Colors.orange[700],
                              ),
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
                          _buildInfoItem(
                            '1. API Key用于访问AI资讯接口',
                          ),
                          _buildInfoItem(
                            '2. 数据缓存24小时，首次访问扣费',
                          ),
                          _buildInfoItem(
                            '3. 请妥善保管你的API Key',
                          ),
                          _buildInfoItem(
                            '4. 如遇问题，请访问官网查看文档',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 关于信息
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                '关于',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAboutItem('应用名称', 'cnm工具箱'),
                          _buildAboutItem('版本', '1.0.0'),
                          _buildAboutItem('API来源', 'api.pearktrue.cn'),
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

  Widget _buildAboutItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
