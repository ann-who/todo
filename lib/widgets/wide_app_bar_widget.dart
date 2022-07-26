import 'package:flutter/material.dart';

import 'package:todo_app/app_theme/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/widgets/app_button.dart';
import 'package:todo_app/resources/app_icons.dart';

class ToDoAppBarWidget extends StatelessWidget {
  const ToDoAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height / 4;

    return SliverAppBar(
      pinned: true,
      expandedHeight: appBarHeight,
      title: ReappearingTitle(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.myToDos,
              style: Theme.of(context).textTheme.headline2,
            ),
            AppIconButton(
              () {},
              IconResources.visibility,
            ),
          ],
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: ReappearingSliver(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.myToDos,
                style: Theme.of(context).textTheme.headline1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.done,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: ToDoColors.labelTertiaryLight,
                        ),
                  ),
                  AppIconButton(
                    () {},
                    IconResources.visibility,
                  ),
                ],
              ),
            ],
          ),
        ),
        centerTitle: false,
      ),
    );
  }
}

// TODO refactor this TERRIBLE implementation
class ReappearingTitle extends StatefulWidget {
  final Widget child;
  const ReappearingTitle({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  ReappearingTitleState createState() {
    return ReappearingTitleState();
  }
}

class ReappearingTitleState extends State<ReappearingTitle> {
  ScrollPosition? _position;
  bool? _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent <= settings.minExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _visible! ? 1 : 0,
      child: widget.child,
    );
  }
}

class ReappearingSliver extends StatefulWidget {
  final Widget child;
  const ReappearingSliver({
    Key? key,
    required this.child,
  }) : super(key: key);
  @override
  ReappearingSliverState createState() {
    return ReappearingSliverState();
  }
}

class ReappearingSliverState extends State<ReappearingSliver> {
  ScrollPosition? _position;
  bool? _visible;
  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _removeListener();
    _addListener();
  }

  void _addListener() {
    _position = Scrollable.of(context)?.position;
    _position?.addListener(_positionListener);
    _positionListener();
  }

  void _removeListener() {
    _position?.removeListener(_positionListener);
  }

  void _positionListener() {
    final FlexibleSpaceBarSettings? settings =
        context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    bool visible =
        settings == null || settings.currentExtent == settings.maxExtent;
    if (_visible != visible) {
      setState(() {
        _visible = visible;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 100),
      opacity: _visible! ? 1 : 0,
      child: widget.child,
    );
  }
}
