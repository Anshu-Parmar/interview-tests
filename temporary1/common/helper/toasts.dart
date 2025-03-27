import 'package:flutter/material.dart';
import 'package:startopreneur/core/configs/routes/home_page_arguments.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';

class SnackBarDisplay extends StatelessWidget {
  final BuildContext context;
  final String message;
  final Color backGroundColor;
  final int? time;
  final bool isActionEnabled;
  final int? tabIndex;
  final BookMarkItem? bookMarkItem;

  const SnackBarDisplay(
      {super.key,
      required this.context,
      required this.message,
      this.backGroundColor = AppColors.primaryColor,
      this.time,
      this.isActionEnabled = false,
      this.bookMarkItem,
      this.tabIndex});

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backGroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: time ?? 1800),
        action: isActionEnabled
            ? SnackBarAction(
                label: "Log in",
                onPressed: () {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Future.delayed(
                    Duration(milliseconds: 1),
                    () {
                      if (context.mounted) {
                        Navigator.pushNamed(
                            context,
                            RouteNames.login,
                            arguments: HomePageArguments(bookMarkItem, tabIndex)
                        );
                      }
                    }
                  );
                })
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
