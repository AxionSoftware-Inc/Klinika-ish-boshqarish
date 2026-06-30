enum UserRole { director, manager, worker }

enum TaskStatus { active, done }

enum Department { reception, laboratory, warehouse, cleaning }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.director:
        return 'Direktor';
      case UserRole.manager:
        return 'Menejer';
      case UserRole.worker:
        return 'Xodim';
    }
  }
}

extension TaskStatusLabel on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.active:
        return 'Faol';
      case TaskStatus.done:
        return 'Tugagan';
    }
  }
}

extension DepartmentLabel on Department {
  String get label {
    switch (this) {
      case Department.reception:
        return 'Qabulxona';
      case Department.laboratory:
        return 'Laboratoriya';
      case Department.warehouse:
        return 'Ombor';
      case Department.cleaning:
        return 'Tozalik';
    }
  }
}
