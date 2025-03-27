import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/common/widget/button/custom_elevated_button.dart';
import 'package:startopreneur/core/configs/assets/app_vectors.dart';
import 'package:startopreneur/core/configs/routes/route_names.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key});

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPageContent("As an ", "Entrepreneur", " you must be at top of all kind news in various sectors...",
                        AppVectors.walkthrough1),
                    _buildPageContent("We curate news for Startup Owners in relevant sectors like ",
                        "Business, Funding, Technology, Management", " etc", AppVectors.walkthrough2),
                    _buildPageContent("Be well informed with Start-O-Preneur and ", "take your business onto next level.", "",
                        AppVectors.walkthrough3),
                  ],
                ),
              ),
              _buildPageIndicator(),
              const SizedBox(height: 10),
              CustomElevatedButton(
                title: _currentPage == 2 ? 'Start - O - Preneur' : 'Next',
                useSingleTap: false,
                onPressed: () {
                  setState(() {
                    if (_currentPage == 2) {
                      Navigator.pushNamedAndRemoveUntil(context, RouteNames.home,  (route) => false,);
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
                      //   (route) => false,
                      // );
                    } else {
                      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.linear);
                    }
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(String initialText, String focusedText, String laterText, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: SvgPicture.asset(
              image,
              fit: BoxFit.scaleDown,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: RichText(
                text: TextSpan(
                  text: initialText,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: context.isDarkMode ? AppColors.lightBackgroundColor : AppColors.darkBackgroundColor),
                  children: [
                    TextSpan(
                        text: focusedText, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
                    TextSpan(text: laterText),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => _buildIndicator(index)),
    );
  }

  Widget _buildIndicator(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),
        width: _currentPage == index ? 12.0 : 8.0,
        height: 7.0,
        decoration: BoxDecoration(
          color: _currentPage >= index ? AppColors.primaryColor : AppColors.neutralGreyColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
