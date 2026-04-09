import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageUtil {
  static const String _apiKeyKey = 'api_key';
  static const String _chatHistoryKey = 'chat_history';

  // 保存API Key
  static Future<bool> saveApiKey(String apiKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_apiKeyKey, apiKey);
    } catch (e) {
      print('保存API Key失败: $e');
      return false;
    }
  }

  // 获取API Key
  static Future<String?> getApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_apiKeyKey);
    } catch (e) {
      print('获取API Key失败: $e');
      return null;
    }
  }

  // 删除API Key
  static Future<bool> removeApiKey() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_apiKeyKey);
    } catch (e) {
      print('删除API Key失败: $e');
      return false;
    }
  }

  // 检查是否已配置API Key
  static Future<bool> hasApiKey() async {
    final apiKey = await getApiKey();
    return apiKey != null && apiKey.isNotEmpty;
  }

  // 保存对话历史
  static Future<bool> saveChatHistory(List<Map<String, dynamic>> messages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(messages);
      return await prefs.setString(_chatHistoryKey, jsonString);
    } catch (e) {
      print('保存对话历史失败: $e');
      return false;
    }
  }

  // 获取对话历史
  static Future<List<Map<String, dynamic>>> getChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_chatHistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('获取对话历史失败: $e');
      return [];
    }
  }

  // 清空对话历史
  static Future<bool> clearChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_chatHistoryKey);
    } catch (e) {
      print('清空对话历史失败: $e');
      return false;
    }
  }
}
