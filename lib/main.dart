import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'core/app_definitions.dart';

void main() {
  runApp(const ClinicTasksApp());
}

class Employee {
  const Employee({
    required this.name,
    required this.role,
    required this.department,
  });

  final String name;
  final UserRole role;
  final Department department;
}

class ClinicTask {
  const ClinicTask({
    required this.id,
    required this.title,
    required this.description,
    required this.assignee,
    required this.createdBy,
    required this.department,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final Employee assignee;
  final UserRole createdBy;
  final Department department;
  final TaskStatus status;

  ClinicTask copyWith({
    String? id,
    String? title,
    String? description,
    Employee? assignee,
    UserRole? createdBy,
    Department? department,
    TaskStatus? status,
  }) {
    return ClinicTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      assignee: assignee ?? this.assignee,
      createdBy: createdBy ?? this.createdBy,
      department: department ?? this.department,
      status: status ?? this.status,
    );
  }
}

class ClinicTasksApp extends StatelessWidget {
  const ClinicTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    const background = Color(0xFFF6F6F2);
    const accent = Color(0xFF1F6F5F);
    const ink = Color(0xFF171717);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klinika',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.fromSeed(seedColor: accent),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: ink,
              displayColor: ink,
            ),
      ),
      home: const TaskBoardScreen(),
    );
  }
}

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  final List<Employee> _employees = const [
    Employee(
      name: 'Dilshod',
      role: UserRole.director,
      department: Department.reception,
    ),
    Employee(
      name: 'Madina',
      role: UserRole.manager,
      department: Department.reception,
    ),
    Employee(
      name: 'Aziza',
      role: UserRole.worker,
      department: Department.reception,
    ),
    Employee(
      name: 'Jasur',
      role: UserRole.worker,
      department: Department.warehouse,
    ),
    Employee(
      name: 'Shahnoza',
      role: UserRole.worker,
      department: Department.laboratory,
    ),
    Employee(
      name: 'Malika',
      role: UserRole.worker,
      department: Department.cleaning,
    ),
  ];

  late Employee _selectedEmployee;
  late List<ClinicTask> _tasks;
  int _selectedTab = 0;

  bool get _canAssign => _selectedEmployee.role != UserRole.worker;
  bool get _showReport => _canAssign && _selectedTab == 1;

  @override
  void initState() {
    super.initState();
    _selectedEmployee = _employees.first;
    _tasks = [
      ClinicTask(
        id: '1',
        title: 'Bugungi qabul xonalarini tayyorlash',
        description:
            'Qabul xonalarini soat 09:00 gacha tayyorlang. Stol usti, navbat qog‘ozlari va kirish qismini tekshirib chiqing.',
        assignee: _employees[2],
        createdBy: UserRole.manager,
        department: Department.reception,
        status: TaskStatus.active,
      ),
      ClinicTask(
        id: '2',
        title: 'Ombordagi dori qoldigini tekshirish',
        description:
            'Asosiy ombordagi qolgan dorilarni sanab chiqing va yetishmayotganlarini alohida ro‘yxat qilib qoldiring.',
        assignee: _employees[3],
        createdBy: UserRole.director,
        department: Department.warehouse,
        status: TaskStatus.active,
      ),
      ClinicTask(
        id: '3',
        title: 'Laboratoriya hisobotini topshirish',
        description:
            'Bugungi laboratoriya natijalari bo‘yicha qisqa hisobotni tayyorlab menejerga yuboring.',
        assignee: _employees[4],
        createdBy: UserRole.manager,
        department: Department.laboratory,
        status: TaskStatus.done,
      ),
      ClinicTask(
        id: '4',
        title: '2-qavat yo‘lagini tayyorlash',
        description:
            '2-qavat yo‘lagida tozalikni tekshiring, pollarni artib chiqing va kutish joyini tayyor holatga keltiring.',
        assignee: _employees[5],
        createdBy: UserRole.manager,
        department: Department.cleaning,
        status: TaskStatus.active,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _selectedEmployee.role == UserRole.worker
        ? _tasks.where((task) => task.assignee.name == _selectedEmployee.name).toList()
        : _tasks;

    return Scaffold(
      floatingActionButton: _canAssign && !_showReport
          ? FloatingActionButton.extended(
              onPressed: _openCreateTaskSheet,
              backgroundColor: const Color(0xFF171717),
              foregroundColor: Colors.white,
              label: const Text('Ish qo‘shish'),
              icon: const Icon(CupertinoIcons.add),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _TopBar(
                employees: _employees,
                selectedEmployee: _selectedEmployee,
                onSelected: (employee) {
                  setState(() {
                    _selectedEmployee = employee;
                    _selectedTab = 0;
                  });
                },
              ),
            ),
            if (_canAssign)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: CupertinoSlidingSegmentedControl<int>(
                  groupValue: _selectedTab,
                  backgroundColor: Colors.white,
                  thumbColor: const Color(0xFF171717),
                  children: const {
                    0: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                      child: Text('Ishlar'),
                    ),
                    1: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                      child: Text('Hisobot'),
                    ),
                  },
                  onValueChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedTab = value;
                    });
                  },
                ),
              ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                children: _showReport
                    ? [
                        Text(
                          'Hisobot',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 14),
                        _ReportView(
                          employees: _employees,
                          tasks: _tasks,
                        ),
                      ]
                    : [
                        Text(
                          'Ishlar',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 14),
                        _TaskList(
                          tasks: tasks,
                          currentEmployee: _selectedEmployee,
                          onToggleDone: _toggleTaskStatus,
                          onOpenTask: _openTaskDetail,
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateTaskSheet() async {
    final workers = _employees.where((employee) => employee.role == UserRole.worker).toList();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    Employee assignee = workers.first;
    TaskStatus status = TaskStatus.active;
    Department department = assignee.department;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E0),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Ish qo‘shish',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _WritingField(
                        child: TextField(
                          controller: titleController,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                          decoration: const InputDecoration(
                            hintText: 'Ish nomi',
                            border: InputBorder.none,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _WritingField(
                        minHeight: 160,
                        child: TextField(
                          controller: descriptionController,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                          decoration: const InputDecoration(
                            hintText: 'To‘liq matn',
                            border: InputBorder.none,
                          ),
                          minLines: 7,
                          maxLines: 10,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<Employee>(
                          initialValue: assignee,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: workers
                              .map(
                                (employee) => DropdownMenuItem<Employee>(
                                  value: employee,
                                  child: Text(employee.name),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (employee) {
                            if (employee == null) return;
                            setSheetState(() {
                              assignee = employee;
                              department = employee.department;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<Department>(
                          initialValue: department,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: Department.values
                              .map(
                                (item) => DropdownMenuItem<Department>(
                                  value: item,
                                  child: Text(item.label),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              department = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<TaskStatus>(
                          initialValue: status,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: TaskStatus.values
                              .map(
                                (item) => DropdownMenuItem<TaskStatus>(
                                  value: item,
                                  child: Text(item.label),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              status = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF171717),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            final title = titleController.text.trim();
                            final description = descriptionController.text.trim();
                            if (title.isEmpty) return;

                            setState(() {
                              _tasks = [
                                ClinicTask(
                                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                                  title: title,
                                  description: description,
                                  assignee: assignee,
                                  createdBy: _selectedEmployee.role,
                                  department: department,
                                  status: status,
                                ),
                                ..._tasks,
                              ];
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Saqlash'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleTaskStatus(ClinicTask task) {
    setState(() {
      _tasks = _tasks
          .map(
            (currentTask) => currentTask.id == task.id
                ? currentTask.copyWith(
                    status: currentTask.status == TaskStatus.active
                        ? TaskStatus.done
                        : TaskStatus.active,
                  )
                : currentTask,
          )
          .toList(growable: false);
    });
  }

  void _openTaskDetail(ClinicTask task) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TaskDetailScreen(
          task: task,
          currentEmployee: _selectedEmployee,
          onToggleDone: () => _toggleTaskStatus(task),
          employees: _employees,
          onSave: _updateTask,
        ),
      ),
    );
  }

  void _updateTask(ClinicTask updatedTask) {
    setState(() {
      _tasks = _tasks
          .map((task) => task.id == updatedTask.id ? updatedTask : task)
          .toList(growable: false);
    });
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.employees,
    required this.selectedEmployee,
    required this.onSelected,
  });

  final List<Employee> employees;
  final Employee selectedEmployee;
  final ValueChanged<Employee> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.square_list, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Klinika',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 128, maxWidth: 180),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Employee>(
                value: selectedEmployee,
                isExpanded: true,
                borderRadius: BorderRadius.circular(18),
                icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                items: employees
                    .map(
                      (employee) => DropdownMenuItem<Employee>(
                        value: employee,
                        child: Text(
                          '${employee.name} · ${employee.role.label}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (employee) {
                  if (employee != null) onSelected(employee);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({
    required this.tasks,
    required this.currentEmployee,
    required this.onToggleDone,
    required this.onOpenTask,
  });

  final List<ClinicTask> tasks;
  final Employee currentEmployee;
  final ValueChanged<ClinicTask> onToggleDone;
  final ValueChanged<ClinicTask> onOpenTask;

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Text('Ish yo‘q'),
      );
    }

    return Column(
      children: tasks
          .map(
            (task) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TaskTile(
                task: task,
                currentEmployee: currentEmployee,
                onToggleDone: () => onToggleDone(task),
                onOpen: () => onOpenTask(task),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.currentEmployee,
    required this.onToggleDone,
    required this.onOpen,
  });

  final ClinicTask task;
  final Employee currentEmployee;
  final VoidCallback onToggleDone;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final isOwner = task.assignee.name == currentEmployee.name;
    final isDone = task.status == TaskStatus.done;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  _StatusBadge(status: task.status),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                task.description.isEmpty ? 'To‘liq matn kiritilmagan' : task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _MetaChip(text: task.department.label),
                  _MetaChip(text: task.assignee.name),
                ],
              ),
              if (isOwner) ...[
                const SizedBox(height: 14),
                SizedBox(
                  height: 40,
                  child: FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: onToggleDone,
                    child: Text(isDone ? 'Qayta ochish' : 'Tugatdim'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.currentEmployee,
    required this.onToggleDone,
    required this.employees,
    required this.onSave,
  });

  final ClinicTask task;
  final Employee currentEmployee;
  final VoidCallback onToggleDone;
  final List<Employee> employees;
  final ValueChanged<ClinicTask> onSave;

  @override
  Widget build(BuildContext context) {
    final isOwner = task.assignee.name == currentEmployee.name;
    final isDone = task.status == TaskStatus.done;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ish'),
        actions: [
          if (currentEmployee.role != UserRole.worker)
            TextButton(
              onPressed: () => _openEditSheet(context),
              child: const Text('Tahrirlash'),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _StatusBadge(status: task.status),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaChip(text: task.department.label),
                      _MetaChip(text: task.assignee.name),
                      _MetaChip(text: task.createdBy.label),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    task.description.isEmpty ? 'To‘liq matn kiritilmagan' : task.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                  if (isOwner) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: FilledButton.tonal(
                        onPressed: () {
                          onToggleDone();
                          Navigator.of(context).pop();
                        },
                        child: Text(isDone ? 'Qayta ochish' : 'Tugatdim'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditSheet(BuildContext context) async {
    final workers = employees.where((employee) => employee.role == UserRole.worker).toList();
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    Employee assignee = task.assignee;
    Department department = task.department;
    TaskStatus status = task.status;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E0),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Ishni tahrirlash',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 16),
                      _WritingField(
                        child: TextField(
                          controller: titleController,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                          decoration: const InputDecoration(
                            hintText: 'Ish nomi',
                            border: InputBorder.none,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _WritingField(
                        minHeight: 180,
                        child: TextField(
                          controller: descriptionController,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                          decoration: const InputDecoration(
                            hintText: 'To‘liq matn',
                            border: InputBorder.none,
                          ),
                          minLines: 8,
                          maxLines: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<Employee>(
                          initialValue: assignee,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(border: InputBorder.none),
                          items: workers
                              .map(
                                (employee) => DropdownMenuItem<Employee>(
                                  value: employee,
                                  child: Text(employee.name),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (employee) {
                            if (employee == null) return;
                            setSheetState(() {
                              assignee = employee;
                              department = employee.department;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<Department>(
                          initialValue: department,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(border: InputBorder.none),
                          items: Department.values
                              .map(
                                (item) => DropdownMenuItem<Department>(
                                  value: item,
                                  child: Text(item.label),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              department = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      _SheetField(
                        child: DropdownButtonFormField<TaskStatus>(
                          initialValue: status,
                          icon: const Icon(CupertinoIcons.chevron_down, size: 18),
                          decoration: const InputDecoration(border: InputBorder.none),
                          items: TaskStatus.values
                              .map(
                                (item) => DropdownMenuItem<TaskStatus>(
                                  value: item,
                                  child: Text(item.label),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: (value) {
                            if (value == null) return;
                            setSheetState(() {
                              status = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF171717),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          onPressed: () {
                            final updatedTitle = titleController.text.trim();
                            if (updatedTitle.isEmpty) return;

                            onSave(
                              task.copyWith(
                                title: updatedTitle,
                                description: descriptionController.text.trim(),
                                assignee: assignee,
                                department: department,
                                status: status,
                              ),
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Saqlash'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _WritingField extends StatelessWidget {
  const _WritingField({
    required this.child,
    this.minHeight = 0,
  });

  final Widget child;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE7E7E2)),
        ),
      ),
      child: child,
    );
  }
}

class _ReportView extends StatelessWidget {
  const _ReportView({
    required this.employees,
    required this.tasks,
  });

  final List<Employee> employees;
  final List<ClinicTask> tasks;

  @override
  Widget build(BuildContext context) {
    final activeCount = tasks.where((task) => task.status == TaskStatus.active).length;
    final doneCount = tasks.where((task) => task.status == TaskStatus.done).length;
    final workers = employees.where((employee) => employee.role == UserRole.worker).toList();

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                label: 'Faol',
                value: '$activeCount',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ReportCard(
                label: 'Tugagan',
                value: '$doneCount',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ReportSection(
          title: 'Bo‘limlar',
          child: Column(
            children: Department.values
                .map(
                  (department) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ReportRow(
                      title: department.label,
                      value: '${tasks.where((task) => task.department == department).length}',
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
        const SizedBox(height: 10),
        _ReportSection(
          title: 'Xodimlar',
          child: Column(
            children: workers
                .map(
                  (employee) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ReportRow(
                      title: employee.name,
                      value:
                          '${tasks.where((task) => task.assignee.name == employee.name && task.status == TaskStatus.active).length}',
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _ReportSection extends StatelessWidget {
  const _ReportSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2EE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) {
    final isDone = status == TaskStatus.done;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFFE5F3EC) : const Color(0xFFF2F2EE),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDone ? const Color(0xFF1C6A50) : const Color(0xFF505050),
            ),
      ),
    );
  }
}
