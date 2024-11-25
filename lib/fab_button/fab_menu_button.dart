import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:taskflow/assets/colors/app_colors.dart';
import 'package:taskflow/delegates/fab_horizontal_delegate.dart';

class FabMenuButton extends StatefulWidget {
  final String listId;
  final VoidCallback onSortByAlpha;
  final VoidCallback onListEdit;
  final VoidCallback onSearch;

  const FabMenuButton(
      {super.key,
      required this.listId,
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
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _checkFirstAccess();
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

  Future<void> _checkFirstAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcaseFabButton =
        prefs.getBool('hasSeenShowcaseFabButton') ?? false;

    if (!hasSeenShowcaseFabButton) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _one,
        ]);
      });
      await prefs.setBool('hasSeenShowcaseFabButton', true);
    }
  }

  Future<void> _checkFirstClick() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenShowcaseOnClick =
        prefs.getBool('hasSeenShowcaseOnClick') ?? false;

    if (!hasSeenShowcaseOnClick) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([_two, _three, _four]);
      });
      await prefs.setBool('hasSeenShowcaseOnClick', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      clipBehavior: Clip.none,
      delegate: FabVerticalDelegate(animation: animation),
      children: <Widget>[
        Showcase(
          key: _one,
          description: "Clique para abrir o menu",
          targetPadding: const EdgeInsets.all(5),
          child: RawMaterialButton(
            fillColor: actionButtonColor,
            padding: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            onPressed: () {
              toggleMenu();
              Future.delayed(
                  const Duration(milliseconds: 300), () => _checkFirstClick());
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
        ),
        Showcase(
          key: _two,
          description: "Organize por ordem alfabética",
          targetPadding: const EdgeInsets.all(5),
          child: RawMaterialButton(
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
        ),
        Showcase(
          key: _three,
          description: "Clique para renomear a lista",
          targetPadding: const EdgeInsets.all(5),
          child: RawMaterialButton(
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
        ),
        Showcase(
          key: _four,
          description: "Busque por uma tarefa",
          targetPadding: const EdgeInsets.all(5),
          child: RawMaterialButton(
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
        ),
      ],
    );
  }
}
