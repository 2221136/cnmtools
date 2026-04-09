import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/image_recognition_model.dart';
import '../models/ai_detection_model.dart';
import '../models/translate_model.dart';
import '../models/chat_model.dart';
import '../utils/storage_util.dart';

class ApiService {
  static const String newsBaseUrl = 'https://api.pearktrue.cn/api/latest_ai_consultative';
  static const String imageRecognitionUrl = 'https://api.pearktrue.cn/api/airecognizeimg/';
  static const String aiDetectionUrl = 'https://api.pearktrue.cn/api/image_identification_chart';
  static const String translateUrl = 'https://api.pearktrue.cn/api/translate/ai/';
  static const String chatUrl = 'https://api.pearktrue.cn/api/xfai/';

  static Future<NewsData?> fetchLatestNews() async {
    try {
      // 从本地存储获取API Key
      final apiKey = await StorageUtil.getApiKey();
      
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('请先在设置中配置API Key');
      }

      final response = await http.get(
        Uri.parse('$newsBaseUrl?key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        
        if (jsonData['code'] == 200) {
          return NewsData.fromJson(jsonData['data']);
        } else {
          throw Exception('API返回错误: ${jsonData['msg']}');
        }
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ImageRecognitionResult> recognizeImage(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(imageRecognitionUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'file': imageUrl}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return ImageRecognitionResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ImageRecognitionResult> recognizeImageFile(String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(imageRecognitionUrl));
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return ImageRecognitionResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<AiDetectionResult> detectAiImage(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse(aiDetectionUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'image': imageUrl}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return AiDetectionResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<AiDetectionResult> detectAiImageFile(String filePath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(aiDetectionUrl));
      request.files.add(await http.MultipartFile.fromPath('image', filePath));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return AiDetectionResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<TranslateResult> translate({
    required String text,
    String? sourceLang,
    String? targetLang,
  }) async {
    try {
      final queryParams = <String, String>{
        'text': text,
      };
      
      if (sourceLang != null && sourceLang.isNotEmpty) {
        queryParams['source_lang'] = sourceLang;
      }
      
      if (targetLang != null && targetLang.isNotEmpty) {
        queryParams['target_lang'] = targetLang;
      }

      final uri = Uri.parse(translateUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return TranslateResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ChatResult> chat(String message, {List<ChatMessage>? context}) async {
    try {
      String fullMessage = message;
      if (context != null && context.isNotEmpty) {
        final recentContext = context.length > 10 
            ? context.sublist(context.length - 10) 
            : context;
        
        final contextStr = recentContext.map((msg) {
          return '${msg.role == 'user' ? '用户' : 'AI'}: ${msg.content}';
        }).join('\n');
        
        fullMessage = '历史对话:\n$contextStr\n\n当前问题: $message';
      }

      final uri = Uri.parse(chatUrl).replace(queryParameters: {
        'message': fullMessage,
      });
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return ChatResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
