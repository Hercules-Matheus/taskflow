import 'package:flutter/material.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/delegates/fab_horizontal_delegate.dart';

class FabMenuButton extends StatefulWidget {
  final String taskListId;
  final VoidCallback onSortByAlpha;
  final VoidCallback onListEdit;
  final VoidCallback onSearch;

  const FabMenuButton(
      {super.key,
      required this.taskListId,
      required this.onSortByAlpha,
      required this.onListEdit,
      required this.onSearch});

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
        vsync: this, duration: const Duration(milliseconds: 200));
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
      delegate: FabHorizontalDelegate(animation: animation),
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
          onPressed: () {
            widget.onListEdit();
          },
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
          onPressed: () {
            widget.onSearch();
          },
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
