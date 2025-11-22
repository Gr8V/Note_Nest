class Note {
  final String id;
  final String title;
  final double content;
  final double date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'date': date,
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],   // 👈 restore saved ID
        title: json['title'],
        content: json['content'] ,
        date: json['date'],
      );
}
