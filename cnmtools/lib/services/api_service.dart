import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';
import '../models/image_recognition_model.dart';
import '../models/ai_detection_model.dart';
import '../models/translate_model.dart';
import '../models/chat_model.dart';
import '../models/font_design_model.dart';
import '../models/douyin_model.dart';
import '../models/bilibili_model.dart';
import '../models/wallpaper_model.dart';
import '../utils/storage_util.dart';

class ApiService {
  static const String newsBaseUrl = 'https://api.pearktrue.cn/api/latest_ai_consultative';
  static const String imageRecognitionUrl = 'https://api.pearktrue.cn/api/airecognizeimg/';
  static const String aiDetectionUrl = 'https://api.pearktrue.cn/api/image_identification_chart';
  static const String translateUrl = 'https://api.pearktrue.cn/api/translate/ai/';
  static const String chatUrl = 'https://api.pearktrue.cn/api/xfai/';
  static const String fontDesignUrl = 'https://api.pearktrue.cn/api/aidesignfont/';
  static const String douyinParseUrl = 'https://api.luosu.top/api/dyjx/index.php';
  static const String bilibiliParseUrl = 'https://api.luosu.top/api/blbljx/index.php';
  static const String wallpaperUrl = 'https://v1.uuhb.cn/v1/wallpaper/random';

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

  static Future<FontDesignResult> designFont({
    required String text,
    String type = 'json',
  }) async {
    try {
      final url = '$fontDesignUrl?text=${Uri.encodeComponent(text)}&type=${Uri.encodeComponent(type)}';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return FontDesignResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<DouyinResult> parseDouyin(String url) async {
    try {
      final requestUrl = '$douyinParseUrl?url=${Uri.encodeComponent(url)}';
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return DouyinResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<BilibiliResult> parseBilibili(String url) async {
    try {
      final requestUrl = '$bilibiliParseUrl?url=${Uri.encodeComponent(url)}';
      final response = await http.get(Uri.parse(requestUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return BilibiliResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<WallpaperResult> getRandomWallpaper({String? keyword}) async {
    try {
      String url = wallpaperUrl;
      if (keyword != null && keyword.isNotEmpty) {
        url = '$wallpaperUrl?keyword=${Uri.encodeComponent(keyword)}';
      }
      
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        return WallpaperResult.fromJson(jsonData);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
