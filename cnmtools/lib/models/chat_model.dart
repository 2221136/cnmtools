class ChatMessage {
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] ?? 'user',
      content: json['content'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}

class ChatResult {
  final int code;
  final String msg;
  final String model;
  final int totalTokens;
  final String message;
  final String answer;

  ChatResult({
    required this.code,
    required this.msg,
    required this.model,
    required this.totalTokens,
    required this.message,
    required this.answer,
  });

  factory ChatResult.fromJson(Map<String, dynamic> json) {
    // 检查answer是在根对象还是在data对象中
    String answer = '';
    String model = '';
    int totalTokens = 0;
    String message = '';
    
    if (json['data'] != null && json['data'] is Map) {
      final data = json['data'] as Map<String, dynamic>;
      answer = data['answer'] ?? '';
      model = data['model'] ?? '';
      totalTokens = data['total_tokens'] ?? 0;
      message = data['message'] ?? '';
    } else {
      answer = json['answer'] ?? '';
      model = json['model'] ?? '';
      totalTokens = json['total_tokens'] ?? 0;
      message = json['message'] ?? '';
    }
    
    return ChatResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      model: model,
      totalTokens: totalTokens,
      message: message,
      answer: answer,
    );
  }
}
