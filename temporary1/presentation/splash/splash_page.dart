import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/core/source/shared_preferences_services.dart';

class SplashPage extends StatefulWidget {

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool redirectNow = true;

  @override
  void initState() {
    redirect();
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.primaryColor,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  height: 145,
                  width: 145,
                  child: Image.asset(
                    AppImages.logoSymbol,
                    fit: BoxFit.contain,
                  )),
              const SizedBox(
                height: 40,
              ),
              RichText(
                text: const TextSpan(
                  text: 'Start - ',
                  style: TextStyle(color: Colors.white, fontSize: 33, fontFamily: 'JosefinSans'),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'O',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: ' - Preneur',
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'An App For Startup Entrepreneurs',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ));
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    // FOR DEBUGGING:
    // await Future.delayed(const Duration(milliseconds: 100));
    bool? isFirstTime = await SharedPreferencesService.isFirstTimeLaunch();

    if (mounted && redirectNow) {
      if (isFirstTime != null && !isFirstTime) {
        Navigator.of(context).pushReplacementNamed(RouteNames.home);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomePage(rateMyApp: widget.rateMyApp),
        //       // builder: (context) => HomePage(),
        //     ));
      } else {
        SharedPreferencesService.saveFirstTimeLaunch(false);
        Navigator.of(context).pushReplacementNamed(RouteNames.walkthrough,);
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const WalkthroughPage(),
        //     ));
      }
    }
  }
}
