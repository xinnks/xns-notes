class Folder {
  final int id;
  final String name;
  final int notesCount;

  Folder({this.id, this.name, this.notesCount = 0});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name
  };
}