import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '待办清单',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFB7299), // B站粉色
          primary: const Color(0xFFFB7299),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFB7299),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // 待办事项列表
  final List<TodoItem> _todos = [];

  // 文本输入控制器
  final TextEditingController _controller = TextEditingController();

  // 当前选中的分类：true = 全部，false = 未完成
  bool _showAll = true;

  // 添加待办事项
  void _addTodo() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _todos.add(TodoItem(text: text));
      _controller.clear();
    });
  }

  // 切换完成状态
  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  // 删除待办事项
  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  // 获取统计信息
  String get _stats {
    final total = _todos.length;
    final done = _todos.where((t) => t.isDone).length;
    return total == 0 ? '添加你的第一个任务吧 ✨' : '已完成 $done / 共 $total';
  }

  // 获取当前显示列表
  List<TodoItem> get _displayTodos {
    if (_showAll) return _todos;
    return _todos.where((t) => !t.isDone).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的待办',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFB7299),
        foregroundColor: Colors.white,
        actions: [
          // 切换显示模式按钮
          IconButton(
            icon: Icon(_showAll ? Icons.checklist : Icons.list),
            onPressed: () {
              setState(() {
                _showAll = !_showAll;
              });
            },
            tooltip: _showAll ? '显示未完成' : '显示全部',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.asset("lib/repositories/images/74330797_p0.png",
                height: 400,
                fit: BoxFit.fitHeight
            )
          ),
          // 输入区域
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '输入新任务...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _addTodo(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB7299),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  child: const Text('添加'),
                ),
              ],
            ),
          ),
          // 统计信息
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              _stats,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          // 待办列表
          Expanded(
            child: _displayTodos.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _showAll ? '还没有待办事项' : '全部已完成！🎉',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _displayTodos.length,
              itemBuilder: (context, index) {
                final todo = _displayTodos[index];
                // 获取在原列表中的真实索引
                final realIndex = _todos.indexOf(todo);
                return TodoCard(
                  todo: todo,
                  onToggle: () => _toggleTodo(realIndex),
                  onDelete: () => _deleteTodo(realIndex),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 待办事项数据模型 ====================
class TodoItem {
  String text;
  bool isDone;

  TodoItem({
    required this.text,
    this.isDone = false,
  });
}

// ==================== 待办事项卡片组件 ====================
class TodoCard extends StatelessWidget {
  final TodoItem todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoCard({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
        leading: GestureDetector(
          onTap: onToggle,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: todo.isDone ? const Color(0xFFFB7299) : Colors.grey.shade400,
                width: 2,
              ),
              color: todo.isDone ? const Color(0xFFFB7299) : Colors.transparent,
            ),
            child: todo.isDone
                ? const Icon(
              Icons.check,
              size: 18,
              color: Colors.white,
            )
                : null,
          ),
        ),
        title: Text(
          todo.text,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            color: todo.isDone ? Colors.grey.shade500 : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.grey.shade400,
          ),
          onPressed: onDelete,
          tooltip: '删除',
        ),
        onTap: onToggle,
      ),
    );
  }
}