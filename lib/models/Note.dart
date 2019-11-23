
class Note {
  final int id; // unique id of note
  final String title; // title of the note
  final String content; // content oof the note
  final String color; // color notation of note
  final int folderId; // folder category of note

  Note({this.id, this.title, this.content, this.color, this.folderId = 0});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'color': color,
    'folder_id': folderId
  };
}