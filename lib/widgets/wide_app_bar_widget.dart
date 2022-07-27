import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/app_theme/app_colors.dart';
import 'package:todo_app/resources/app_constants.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/resources/app_icons.dart';

class WideAppBarWidget extends StatelessWidget {
  const WideAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: MyHeaderDelegate(
        MediaQuery.of(context).size.height / 4,
      ),
    );
  }
}

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double appBarExpandedHeight;

  const MyHeaderDelegate(this.appBarExpandedHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / maxExtent;
    const int animationDuration = 100;
    Brightness brightness = Theme.of(context).brightness;

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          AnimatedContainer(
            color: brightness == Brightness.light
                ? ToDoColors.backPrimaryLight
                : Color.lerp(ToDoColors.backPrimaryDark,
                    ToDoColors.backSecondaryDark, progress),
            duration: const Duration(milliseconds: animationDuration),
          ),

          // Animated title and subtitle
          AnimatedContainer(
            duration: const Duration(milliseconds: animationDuration),
            padding: EdgeInsets.lerp(
              const EdgeInsets.only(
                  left: WidgetsSettings.wideAppBarBiggestPadding),
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
                        fontSize: lerpDouble(WidgetsSettings.appLargeTitle,
                            WidgetsSettings.appTitle, progress),
                      ),
                ),
                AnimatedOpacity(
                  opacity: 1 - progress,
                  duration: const Duration(milliseconds: animationDuration),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.done,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Animated icon button
          Positioned(
            // TODO how to calculate position?
            bottom: lerpDouble(-15, 7, progress),
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: animationDuration),
              padding: EdgeInsets.lerp(
                const EdgeInsets.only(
                  right: WidgetsSettings.titlePadding,
                  bottom: WidgetsSettings.noPadding,
                ),
                const EdgeInsets.only(
                    right: WidgetsSettings.noPadding,
                    top: WidgetsSettings.wideAppBarMediumPadding),
                progress,
              ),
              alignment: Alignment.lerp(
                Alignment.bottomRight,
                Alignment.centerRight,
                progress,
              ),
              child: AppIconButton(
                () {},
                IconResources.visibility,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => appBarExpandedHeight;

  // TODO calculate (how to get appBar standart height?)
  @override
  double get minExtent => 84;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}

class AnimatedBackground {}
