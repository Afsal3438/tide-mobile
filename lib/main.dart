import 'package:flutter/material.dart';

void main() {
  runApp(const TideApp());
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final weekday = weekdays[date.weekday - 1];
  final month = months[date.month - 1];
  return '$weekday, $month ${date.day}, ${date.year}';
}

String formatDateShort(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  final month = months[date.month - 1];
  return '$month ${date.day}, ${date.year}';
}

class TideColors {
  static const primary = Color(0xFF3CDDC7);
  static const primaryDark = Color(0xFF003731);
  static const secondary = Color(0xFFF5A623);
  static const ink = Color(0xFFD8E3FB);
  static const inkMuted = Color(0xFFC6C6CD);
  static const surface = Color(0xFF040E1F);
  static const card = Color(0xFF1E293B);
  static const border = Color(0xFF152031);
  static const priHigh = Color(0xFFE8654F);
  static const priMed = Color(0xFFF5A623);
  static const priLow = Color(0xFF3CDDC7);
  static const catWork = Color(0xFF5B8DEF);
  static const catPersonal = Color(0xFFF5A623);
  static const catStudy = Color(0xFFA78BFA);
}

class TideSpace {
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
}

class Task {
  final String title;
  final String priority;
  final String category;
  bool isDone;
  DateTime dueDate;

  Task({
    required this.title,
    this.priority = 'med',
    this.category = 'Personal',
    this.isDone = false,
    DateTime? dueDate,
  }) : dueDate = dueDate ?? DateTime.now();

  Color get priorityColor {
    if (priority == 'high') return TideColors.priHigh;
    if (priority == 'low') return TideColors.priLow;
    return TideColors.priMed;
  }

  Color get categoryColor {
    if (category == 'Work') return TideColors.catWork;
    if (category == 'Study') return TideColors.catStudy;
    return TideColors.catPersonal;
  }
}

class TideApp extends StatelessWidget {
  const TideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tide',
      theme: ThemeData(
        scaffoldBackgroundColor: TideColors.surface,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: TideColors.primary,
          brightness: Brightness.dark,
          surface: TideColors.surface,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tasks = [
    Task(title: 'Submit DBMS assignment', priority: 'high', category: 'Study'),
    Task(title: 'Call Amma 6 PM', category: 'Personal'),
    Task(title: 'Gym - leg day', priority: 'low', category: 'Personal'),
    Task(title: 'Review Figma prototype', isDone: true, category: 'Work'),
  ];

  String _filter = 'All';

  void _toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
  }

  void _addTask(
      String title, String priority, DateTime dueDate, String category) {
    if (title.trim().isEmpty) return;
    setState(() {
      tasks.add(Task(
        title: title.trim(),
        priority: priority,
        dueDate: dueDate,
        category: category,
      ));
    });
  }

  void _openAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddTaskSheet(onAdd: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = tasks.where((t) => !t.isDone).length;
    final filteredTasks = _filter == 'All'
        ? tasks
        : tasks.where((t) => t.category == _filter).toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A1A2F), TideColors.surface],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Good evening',
                            style: TextStyle(
                                fontSize: 14,
                                color: TideColors.inkMuted,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        const Text('Today',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                color: TideColors.ink,
                                letterSpacing: -0.5)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: TideColors.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: TideColors.primary.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '$remaining left',
                        style: const TextStyle(
                            color: TideColors.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: TideColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: TideColors.border),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _filter,
                      isExpanded: true,
                      dropdownColor: TideColors.card,
                      icon: const Icon(Icons.expand_more,
                          color: TideColors.inkMuted),
                      style: const TextStyle(
                          color: TideColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                      items: ['All', 'Work', 'Personal', 'Study'].map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Row(
                            children: [
                              if (c != 'All')
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: c == 'Work'
                                        ? TideColors.catWork
                                        : c == 'Study'
                                            ? TideColors.catStudy
                                            : TideColors.catPersonal,
                                  ),
                                ),
                              Text(c == 'All' ? 'All categories' : c),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _filter = value!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: filteredTasks.isEmpty
                      ? Center(
                          child: Text(
                              tasks.isEmpty
                                  ? 'No tasks yet — tap + to add one'
                                  : 'No tasks in this category',
                              style:
                                  const TextStyle(color: TideColors.inkMuted)),
                        )
                      : ListView(
                          physics: const BouncingScrollPhysics(),
                          children: filteredTasks
                              .map((t) => TaskCard(
                                  task: t, onTap: () => _toggleTask(t)))
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: TideColors.primary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: TideColors.primaryDark, size: 28),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  const TaskCard({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: TideColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: TideColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.isDone ? TideColors.primary : TideColors.primary,
                  width: 2,
                ),
                color: task.isDone ? TideColors.primary : Colors.transparent,
              ),
              child: task.isDone
                  ? const Icon(Icons.check,
                      size: 16, color: TideColors.primaryDark)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: task.isDone ? TideColors.inkMuted : TideColors.ink,
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formatDateShort(task.dueDate),
                        style: const TextStyle(
                            fontSize: 12, color: TideColors.inkMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: task.categoryColor.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: task.categoryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.priorityColor,
                boxShadow: [
                  BoxShadow(
                    color: task.priorityColor.withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTaskSheet extends StatefulWidget {
  final void Function(String, String, DateTime, String) onAdd;
  const AddTaskSheet({super.key, required this.onAdd});
  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();
  String _priority = 'med';
  String _category = 'Personal';
  DateTime _dueDate = DateTime.now();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: TideColors.primary,
              onPrimary: TideColors.primaryDark,
              surface: TideColors.card,
              onSurface: TideColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: TideColors.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: TideColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Text('New task',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: TideColors.ink)),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'What needs doing?',
                filled: true,
                fillColor: TideColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: TideColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 18, color: TideColors.primary),
                    const SizedBox(width: 10),
                    Text(
                      formatDate(_dueDate),
                      style:
                          const TextStyle(color: TideColors.ink, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: ['high', 'med', 'low'].map((p) {
                final selected = _priority == p;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(p.toUpperCase()),
                    selected: selected,
                    selectedColor: TideColors.primary,
                    backgroundColor: TideColors.surface,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? TideColors.primaryDark
                          : TideColors.inkMuted,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide.none,
                    ),
                    onSelected: (_) => setState(() => _priority = p),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: TideColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _category,
                  isExpanded: true,
                  dropdownColor: TideColors.card,
                  icon:
                      const Icon(Icons.expand_more, color: TideColors.inkMuted),
                  style: const TextStyle(color: TideColors.ink, fontSize: 14),
                  items: ['Work', 'Personal', 'Study'].map((c) {
                    final color = c == 'Work'
                        ? TideColors.catWork
                        : c == 'Study'
                            ? TideColors.catStudy
                            : TideColors.catPersonal;
                    return DropdownMenuItem(
                      value: c,
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: color),
                          ),
                          Text(c),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _category = value!),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: TideColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  widget.onAdd(
                      _controller.text, _priority, _dueDate, _category);
                  Navigator.pop(context);
                },
                child: const Text('Save Task',
                    style: TextStyle(
                        color: TideColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

