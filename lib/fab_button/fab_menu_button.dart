import 'package:flutter/material.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/delegates/fab_vertical_delegate.dart';
import 'package:taskflow/pages/list/list_edit_page.dart';
import 'package:taskflow/pages/list/list_page.dart';
import 'package:taskflow/pages/task/task_page.dart';
import 'package:taskflow/repository/tasks_repository.dart';

class FabMenuButton extends StatefulWidget {
  final String taskListName;
  final int taskListId;
  final VoidCallback onSortByAlpha;

  const FabMenuButton(
      {Key? key,
      required this.taskListName,
      required this.taskListId,
      required this.onSortByAlpha})
      : super(key: key);

  @override
  State<FabMenuButton> createState() => _FabMenuButtonState();
}

class _FabMenuButtonState extends State<FabMenuButton>
    with SingleTickerProviderStateMixin {
  final actionButtonColor = AppColors.primaryGreenColor;
  late AnimationController animation;
  final menuIsOpen = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  toggleMenu() {
    menuIsOpen.value ? animation.reverse() : animation.forward();
    menuIsOpen.value = !menuIsOpen.value;
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FabVerticalDelegate(animation: animation),
      children: <Widget>[
        RawMaterialButton(
          fillColor: actionButtonColor,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onPressed: () {
            toggleMenu();
          },
          constraints: const BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          child: const Icon(
            Icons.more_vert,
            color: AppColors.primaryWhiteColor,
          ),
        ),
        RawMaterialButton(
          fillColor: actionButtonColor,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onPressed: () {
            widget.onSortByAlpha();
          },
          constraints: const BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          child: const Icon(
            Icons.sort_by_alpha,
            color: AppColors.primaryWhiteColor,
          ),
        ),
        RawMaterialButton(
          fillColor: actionButtonColor,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onPressed: () {},
          constraints: const BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          child: const Icon(
            Icons.edit,
            color: AppColors.primaryWhiteColor,
          ),
        ),
        RawMaterialButton(
          fillColor: actionButtonColor,
          padding: const EdgeInsets.all(10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          onPressed: () {},
          constraints: const BoxConstraints.tightFor(
            width: 56.0,
            height: 56.0,
          ),
          child: const Icon(
            Icons.search,
            color: AppColors.primaryWhiteColor,
          ),
        ),
      ],
    );
  }
}
