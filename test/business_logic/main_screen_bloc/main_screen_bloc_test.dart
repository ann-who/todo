import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import '../../data/repository/fake_task_repository.dart';
import 'package:todo_app/models/task_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group(
    'Tests for Main Screen Bloc',
    () {
      late TasksMainScreenBloc tasksMainScreenBloc;

      setUp(() async {
        tasksMainScreenBloc = TasksMainScreenBloc(
          taskRepository: FakeTaskRepository(),
          isTesting: true,
        );
      });

      test('Screen initial state is ordinary', () {
        expect(
          tasksMainScreenBloc.state,
          const TasksMainScreenState(status: TasksMainScreenStatus.ordinary),
        );
      });

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Refresh tasks list',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(const TasksListRefreshed()),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(status: TasksMainScreenStatus.loading),
          const TasksMainScreenState(status: TasksMainScreenStatus.ordinary),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Change task text',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(const TaskTextChanged('test task')),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(
            status: TasksMainScreenStatus.ordinary,
            newTaskText: 'test task',
          ),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Create task',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc
          ..add(const TaskTextChanged('test task'))
          ..add(const TaskSubmitted()),
        skip: 1,
        expect: () {
          var newTask = Task.minimal('test task').copyWith(
            id: '0',
            createdAt: -1,
            changedAt: -1,
          );

          return <TasksMainScreenState>[
            const TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              newTaskText: 'test task',
            ),
            TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              newTaskText: 'test task',
              tasksList: <Task>[newTask],
            ),
            TasksMainScreenState(
              status: TasksMainScreenStatus.ordinary,
              tasksList: <Task>[newTask],
              newTaskText: '',
            ),
          ];
        },
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Delete task',
        build: () => tasksMainScreenBloc,
        act: (bloc) async {
          bloc.add(const TaskTextChanged('test task'));
          bloc.add(const TaskSubmitted());
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(
            TaskFromListDeleted(Task.minimal('test task').copyWith(id: '0')),
          );
        },
        skip: 4,
        expect: () {
          var newTask = Task.minimal('test task').copyWith(
            id: '0',
            createdAt: -1,
            changedAt: -1,
          );

          return <TasksMainScreenState>[
            TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              tasksList: <Task>[newTask],
            ),
            const TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              tasksList: <Task>[],
            ),
            const TasksMainScreenState(
              status: TasksMainScreenStatus.ordinary,
              tasksList: <Task>[],
            ),
          ];
        },
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Delete not existing task',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(
          TaskFromListDeleted(Task.minimal('test task')),
        ),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(
            status: TasksMainScreenStatus.onDataChanges,
            tasksList: [],
          ),
          const TasksMainScreenState(
            status: TasksMainScreenStatus.failure,
            errorStatus: TasksMainScreenError.onDeleteError,
          ),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Toggle task',
        build: () => tasksMainScreenBloc,
        act: (bloc) async {
          bloc.add(const TaskTextChanged('test task'));
          bloc.add(const TaskSubmitted());
          await Future.delayed(const Duration(milliseconds: 100));
          bloc.add(
            TaskCompletionToggled(Task.minimal('test task').copyWith(id: '0')),
          );
        },
        skip: 4,
        expect: () {
          var newTask = Task.minimal('test task').copyWith(
            id: '0',
            createdAt: -1,
            changedAt: -1,
          );

          return <TasksMainScreenState>[
            TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              tasksList: <Task>[newTask],
            ),
            TasksMainScreenState(
              status: TasksMainScreenStatus.onDataChanges,
              tasksList: <Task>[newTask.copyWith(done: true)],
            ),
            TasksMainScreenState(
              status: TasksMainScreenStatus.ordinary,
              tasksList: <Task>[newTask.copyWith(done: true)],
            ),
          ];
        },
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Toggle not existing task',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(
          TaskCompletionToggled(Task.minimal('test task')),
        ),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(
            status: TasksMainScreenStatus.onDataChanges,
            tasksList: [],
          ),
          const TasksMainScreenState(
            status: TasksMainScreenStatus.failure,
            errorStatus: TasksMainScreenError.onUpdateError,
          ),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Hide done tasks',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(
          const DoneTasksVisibilityToggled(),
        ),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(
            isDoneTasksVisible: false,
          ),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Open creation view by using FAB',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(
          const TaskCreationOpened(),
        ),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(status: TasksMainScreenStatus.onCreate),
        ],
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Open edit view by using trailing icon button',
        build: () => tasksMainScreenBloc,
        seed: () => TasksMainScreenState(
          status: TasksMainScreenStatus.ordinary,
          taskOnEdition: Task.minimal('test task').copyWith(id: '0'),
        ),
        act: (bloc) => bloc.add(
          TaskEditOpened(Task.minimal('test task').copyWith(id: '0')),
        ),
        expect: () {
          var tastToEdit = Task.minimal('test task').copyWith(id: '0');
          return <TasksMainScreenState>[
            TasksMainScreenState(
              status: TasksMainScreenStatus.onEdit,
              taskOnEdition: tastToEdit,
            ),
          ];
        },
      );

      blocTest<TasksMainScreenBloc, TasksMainScreenState>(
        'Complete task edition',
        build: () => tasksMainScreenBloc,
        act: (bloc) => bloc.add(
          const TaskEditCompleted(),
        ),
        expect: () => <TasksMainScreenState>[
          const TasksMainScreenState(
            status: TasksMainScreenStatus.ordinary,
            taskOnEdition: null,
          ),
        ],
      );
    },
  );
}
