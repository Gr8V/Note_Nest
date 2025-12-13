class Note {
  final String id;
  final String title;
  final String content;
  final String date;
  final bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.isPinned
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date,
        'isPinned': isPinned
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],   // 👈 restore saved ID
        title: json['title'],
        content: json['content'] ,
        date: json['date'],
        isPinned: json['isPinned']
      );
}
