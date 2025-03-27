import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/widget/appbar/custom_app_bar.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/edit_profile_arguments.dart';
import 'package:startopreneur/core/configs/routes/home_page_arguments.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/domain/entities/news/book_mark_news.dart';
import 'package:startopreneur/presentation/auth/pages/forgot_password_page.dart';
import 'package:startopreneur/presentation/auth/pages/login_page.dart';
import 'package:startopreneur/presentation/auth/pages/signup_page.dart';
import 'package:startopreneur/presentation/channels/pages/channels_page.dart';
import 'package:startopreneur/presentation/home/pages/home_page.dart';
import 'package:startopreneur/presentation/news/pages/web_news_page.dart';
import 'package:startopreneur/presentation/settings/pages/display_settings_page.dart';
import 'package:startopreneur/presentation/settings/pages/edit_profile_page.dart';
import 'package:startopreneur/presentation/settings/pages/settings/guest_settings_menu.dart';
import 'package:startopreneur/presentation/settings/pages/settings/settings_menu.dart';
import 'package:startopreneur/presentation/splash/splash_page.dart';
import 'package:startopreneur/presentation/walkthrough/pages/walkthrough_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashPage());

      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => HomePage(),);

      case RouteNames.walkthrough:
        return MaterialPageRoute(builder: (_) => WalkthroughPage());
      case RouteNames.login:
        if(args is HomePageArguments) {
          final HomePageArguments newArgs = settings.arguments as HomePageArguments;
          return MaterialPageRoute(builder: (_) => LogInPage(
            tabIndex: newArgs.tabIndex,
            bookMarkItem: newArgs.bookMarkItem,
          ));
        } else {
          return MaterialPageRoute(builder: (_) => LogInPage());
        }
      case RouteNames.signup:
        if(args is HomePageArguments) {
          final HomePageArguments newArgs = settings.arguments as HomePageArguments;
          return MaterialPageRoute(builder: (_) => SignupPage(
            tabIndex: newArgs.tabIndex,
            bookMarkItem: newArgs.bookMarkItem,
          ));
        } else {
          return MaterialPageRoute(builder: (_) => SignupPage());
        }
      case RouteNames.forgotPwd:
        return MaterialPageRoute(builder: (_) => ForgotPasswordPage());

      case RouteNames.webNewsPage:
        final BookMarkItem newArgs = settings.arguments as BookMarkItem;
        return MaterialPageRoute(builder: (_) => WebNewsPage(bookMarkItem: newArgs));

      case RouteNames.channelPage:
        return MaterialPageRoute(builder: (_) => ChannelPage());

      case RouteNames.displaySetting:
        return MaterialPageRoute(builder: (_) => DisplaySettingsPage());

      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => SettingsMenu());
      case RouteNames.guestSettings:
        return MaterialPageRoute(builder: (_) => GuestSettingsMenu());

      case RouteNames.editProfilePage:
        final EditProfileArguments newArgs = settings.arguments as EditProfileArguments;
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(
            user: newArgs.user,
            provider: newArgs.provider
          )
        );

      case "/deeplink/splash":
        return MaterialPageRoute(builder: (_) => SplashPage());

      case "/deeplink/home":
        return MaterialPageRoute(builder: (_) => HomePage(),);

      case "/deeplink/channels":
        return MaterialPageRoute(builder: (_) => ChannelPage());

      case "/deeplink/settings":
        return MaterialPageRoute(builder: (_) => SettingsMenu());

      case "/deeplink/displaySettings":
        return MaterialPageRoute(builder: (_) => DisplaySettingsPage());

      default:
        return  _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: CustomAppBar(
          title: "Page 404",
          showBackButton: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                AppVectors.notFound,
                fit: BoxFit.scaleDown,
                height: 150,
              ),
              const SizedBox(height: 10.0,),
              Text('Error in page loading')
            ],
          ),
        )
      );
    });
  }
}
