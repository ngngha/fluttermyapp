class Task {
  String id;
  String projectId;
  String projectName;
  String title;
  String employee;
  String employeeId;
  String detail;
  DateTime? createdAt;
  DateTime? updatedAt;
  Task(
      {this.id = '',
      required this.projectId,
      required this.projectName,
      required this.title,
      required this.employee,
      required this.employeeId,
      required this.detail,
      this.createdAt,
      this.updatedAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'projectName': projectName,
        'title': title,
        'employee': employee,
        'employeeId': employeeId,
        'detail': detail,
      };
  static Task fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        projectId: json['projectId'],
        projectName: json['projectName'],
        title: json['title'],
        employee: json['employee'],
        employeeId: json['employeeId'],
        detail: json['detail'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
      );
}
