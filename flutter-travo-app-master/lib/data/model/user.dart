class User {
  String id;
  String username;
  String email;
  String detail;
  DateTime? dateOfBirth;
  String level;
  User(
      {this.id = '',
      this.username = '' ,
      this.email = '',
      this.detail = '',
      this.dateOfBirth,
      this.level = ''});

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'detail': detail,
        'dateOfBirth': dateOfBirth,
        'level': level,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        detail: json['detail'],
        dateOfBirth: json['dateOfBirth'],
        level: json['level'],
      );
}
