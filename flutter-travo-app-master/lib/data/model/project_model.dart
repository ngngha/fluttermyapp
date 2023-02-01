class Project {
  String id;
  String name;
  String user;
  String detail;
  Project(
      {this.id = '',
      required this.name,
      required this.user,
      required this.detail});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'user': user,
        'detail': detail,
      };
  static Project fromJson(Map<String, dynamic> json) => Project(
        id: json['id'],
        name: json['name'],
        user: json['user'],
        detail: json['detail'],
      );
}
