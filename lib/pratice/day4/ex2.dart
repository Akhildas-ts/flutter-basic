import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Model - Like your domain entity in Go
class Todo extends Equatable {
  final String id;
  final String title;
  final bool isCompleted;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  Todo copyWith({String? title, bool? isCompleted}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted];
}

enum TodoFilter { all, active, completed }

// ============================================================================
// EVENTS - Like HTTP request types (GET, POST, PUT, DELETE)
// ============================================================================

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddTodo extends TodoEvent {
  final String title;

  AddTodo(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTodo extends TodoEvent {
  final String id;

  ToggleTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteTodo extends TodoEvent {
  final String id;

  DeleteTodo(this.id);

  @override
  List<Object?> get props => [id];
}

class FilterChanged extends TodoEvent {
  final TodoFilter filter;

  FilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

// ============================================================================
// STATE - Like your API response structure
// ============================================================================

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;
  final bool isAdding;
  final String? error;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
    this.isAdding = false,
    this.error,
  });

  // Computed property for filtered todos
  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.all:
        return todos;
      case TodoFilter.active:
        return todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((t) => t.isCompleted).toList();
    }
  }

  // Statistics
  int get totalCount => todos.length;
  int get completedCount => todos.where((t) => t.isCompleted).length;
  int get activeCount => totalCount - completedCount;

  TodoState copyWith({
    List<Todo>? todos,
    TodoFilter? filter,
    bool? isAdding,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      isAdding: isAdding ?? this.isAdding,
      error: error,
    );
  }

  @override
  List<Object?> get props => [todos, filter, isAdding, error];
}

// ============================================================================
// BLOC - Like your service layer + controller in Go
// ============================================================================

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(const TodoState()) {
    // Register event handlers - like route handlers
    on<AddTodo>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<FilterChanged>(_onFilterChanged);
  }

  // Handler: Add Todo
  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (event.title.trim().isEmpty) return;

    // Show loading state
    emit(state.copyWith(isAdding: true));

    // Simulate API call (like time.Sleep in Go)
    await Future.delayed(const Duration(milliseconds: 500));

    // Create new todo
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: event.title.trim(),
    );

    // Add to list
    final updatedTodos = [...state.todos, newTodo];

    // Emit new state
    emit(state.copyWith(
      todos: updatedTodos,
      isAdding: false,
    ));
  }

  // Handler: Toggle Todo completion
  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == event.id) {
        return todo.copyWith(isCompleted: !todo.isCompleted);
      }
      return todo;
    }).toList();

    emit(state.copyWith(todos: updatedTodos));
  }

  // Handler: Delete Todo
  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    final updatedTodos = state.todos.where((t) => t.id != event.id).toList();
    emit(state.copyWith(todos: updatedTodos));
  }

  // Handler: Change Filter
  void _onFilterChanged(FilterChanged event, Emitter<TodoState> emit) {
    emit(state.copyWith(filter: event.filter));
  }
}

// ============================================================================
// UI - Like your frontend template/view
// ============================================================================

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: const TodoView(),
    );
  }
}

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLoC Todo App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Statistics Bar
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return Container(
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Total',
                      count: state.totalCount,
                      color: Colors.blue,
                    ),
                    _StatItem(
                      label: 'Active',
                      count: state.activeCount,
                      color: Colors.orange,
                    ),
                    _StatItem(
                      label: 'Completed',
                      count: state.completedCount,
                      color: Colors.green,
                    ),
                  ],
                ),
              );
            },
          ),

          // Filter Chips
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: state.filter == TodoFilter.all,
                      onTap: () => context.read<TodoBloc>().add(
                            FilterChanged(TodoFilter.all),
                          ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Active',
                      isSelected: state.filter == TodoFilter.active,
                      onTap: () => context.read<TodoBloc>().add(
                            FilterChanged(TodoFilter.active),
                          ),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completed',
                      isSelected: state.filter == TodoFilter.completed,
                      onTap: () => context.read<TodoBloc>().add(
                            FilterChanged(TodoFilter.completed),
                          ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(height: 1),

          // Add Todo Input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'What needs to be done?',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) => _addTodo(context),
                  ),
                ),
                const SizedBox(width: 8),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.isAdding ? null : () => _addTodo(context),
                      child: state.isAdding
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add'),
                    );
                  },
                ),
              ],
            ),
          ),

          // Todo List
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                final todos = state.filteredTodos;

                if (todos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 100, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          'No todos yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return _TodoItem(todo: todo);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addTodo(BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      context.read<TodoBloc>().add(AddTodo(_controller.text));
      _controller.clear();
    }
  }
}

// ============================================================================
// WIDGETS - Reusable components
// ============================================================================

class _StatItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade200,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _TodoItem extends StatelessWidget {
  final Todo todo;

  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) {
          context.read<TodoBloc>().add(ToggleTodo(todo.id));
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          color: todo.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          context.read<TodoBloc>().add(DeleteTodo(todo.id));
        },
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: TodoPage()));