import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/business_logic/main_screen/bloc_for_main_screen.dart';
import 'package:todo_app/presentation/widgets/buttons/app_icon_button.dart';
import 'package:todo_app/resources/app_constants.dart';

class WideAppBarWidget extends StatelessWidget {
  const WideAppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MyHeaderDelegate(
        appBarExpandedHeight: MediaQuery.of(context).size.height <= 800
            ? MediaQuery.of(context).size.height / 4
            : MediaQuery.of(context).size.height / 8,
        statusBarHeight: MediaQuery.of(context).viewPadding.top,
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double appBarExpandedHeight;
  final double statusBarHeight;

  const MyHeaderDelegate({
    required this.appBarExpandedHeight,
    required this.statusBarHeight,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    Brightness brightness = Theme.of(context).brightness;

    return Material(
      child: Stack(
        fit: StackFit.loose,
        children: [
          // Background
          AnimatedContainer(
            color: brightness == Brightness.light
                ? Theme.of(context).appBarTheme.backgroundColor
                : Color.lerp(
                    Theme.of(context).appBarTheme.backgroundColor,
                    ToDoColors.backSecondaryDark,
                    progress,
                  ),
            duration: const Duration(
              milliseconds: WidgetsSettings.animationDuration,
            ),
          ),

          // Animated title and subtitle
          AnimatedContainer(
            duration: const Duration(
              milliseconds: WidgetsSettings.animationDuration,
            ),
            padding: EdgeInsets.lerp(
              const EdgeInsets.only(
                left: WidgetsSettings.wideAppBarBiggestPadding,
              ),
              const EdgeInsets.only(
                left: WidgetsSettings.wideAppBarSmallPadding,
                top: WidgetsSettings.wideAppBarMediumPadding,
              ),
              progress,
            ),
            alignment: Alignment.lerp(
              Alignment.bottomLeft,
              Alignment.centerLeft,
              progress,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.myToDos,
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: lerpDouble(
                          WidgetsSettings.appLargeTitle,
                          WidgetsSettings.appTitle,
                          progress,
                        ),
                      ),
                ),
                AnimatedOpacity(
                  opacity: 1 - progress,
                  duration: const Duration(
                    milliseconds: WidgetsSettings.animationDuration,
                  ),
                  child: BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
                    builder: (context, state) {
                      return Text(
                        '${AppLocalizations.of(context)!.done} — ${state.doneTasksCount}',
                        style: Theme.of(context).textTheme.subtitle1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Animated divider
          Container(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              duration: const Duration(
                milliseconds: WidgetsSettings.animationDuration,
              ),
              opacity: progress / 4,
              child: Container(
                height: WidgetsSettings.dividerHeight,
                decoration: BoxDecoration(
                  color: brightness == Brightness.light
                      ? ToDoColors.separatorLight
                      : ToDoColors.separatorDark,
                  boxShadow: [
                    BoxShadow(
                      color: brightness == Brightness.light
                          ? ToDoColors.grayLight
                          : ToDoColors.grayDark,
                      spreadRadius: WidgetsSettings.dividerHeight,
                      blurRadius: 2.0,
                      blurStyle: BlurStyle.normal,
                      offset: const Offset(
                        0,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Animated icon button
          Positioned(
            bottom: lerpDouble(
              -5,
              12,
              progress,
            ),
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: WidgetsSettings.animationDuration,
              ),
              padding: EdgeInsets.lerp(
                const EdgeInsets.only(
                  right: WidgetsSettings.titlePadding,
                  bottom: WidgetsSettings.noPadding,
                ),
                const EdgeInsets.only(
                  right: WidgetsSettings.noPadding,
                  top: WidgetsSettings.wideAppBarMediumPadding,
                ),
                progress,
              ),
              alignment: Alignment.lerp(
                Alignment.bottomRight,
                Alignment.centerRight,
                progress,
              ),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: WidgetsSettings.animationDuration,
                ),
                child: BlocBuilder<TasksMainScreenBloc, TasksMainScreenState>(
                  builder: (context, state) {
                    return AppIconButton(
                      onPressed: () => context
                          .read<TasksMainScreenBloc>()
                          .add(const DoneTasksVisibilityToggled()),
                      iconPath: state.isDoneTasksVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => appBarExpandedHeight;

  @override
  double get minExtent => AppBar().preferredSize.height + statusBarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
