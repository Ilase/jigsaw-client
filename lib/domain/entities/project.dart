class Project {
  final int id;
  final String title;
  final String description;
  final String owner;
  final List<String> collaborators;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.owner,
    required this.collaborators,
  });
}
