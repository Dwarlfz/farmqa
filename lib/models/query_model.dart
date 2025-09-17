class QueryModel {
  final String id;
  final String userId;
  final String question;
  final String? answer;
  final bool resolved;
  final int createdAt;

  QueryModel({
    required this.id,
    required this.userId,
    required this.question,
    this.answer,
    this.resolved = false,
    required this.createdAt,
  });

  factory QueryModel.fromMap(Map<String, dynamic> m, String id) {
    return QueryModel(
      id: id,
      userId: m['userId'] as String? ?? '',
      question: m['question'] as String? ?? '',
      answer: m['answer'] as String?,
      resolved: m['resolved'] as bool? ?? false,
      createdAt: (m['createdAt'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'question': question,
      'answer': answer,
      'resolved': resolved,
      'createdAt': createdAt,
    };
  }
}
