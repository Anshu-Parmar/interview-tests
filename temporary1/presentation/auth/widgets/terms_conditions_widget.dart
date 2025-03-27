import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';

class CustomTermsAndConditionsBottomSheet {
  static showModelBottomSheet(BuildContext context, {required String heading}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
            snap: true,
            expand: false,
            //UPDATED to 1 and 0.9 to make the bottom sheet fullscreen
            initialChildSize: 1,
            minChildSize: 0.9,
            maxChildSize: 1,
            builder: (context, scrollController) {
            return Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: SingleChildScrollView(
                  controller: scrollController,
                    child: Column(
                      children: [
                        _customTextBox(
                            text: heading,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            textAlign: TextAlign.center
                        ),
                        _customDivider(context),
                        _customTextBox(
                          text: "Last updated: December 23, 2024",
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                        ),
                        _customSizeBox(h: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTermsAndConditions(
                            topic: "General Information",
                            description: "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of "
                                  "Your information when You use the Service and tells You about Your privacy rights and how the law "
                                  "protects You. We use Your Personal data to provide and improve the Service. By using the Service, "
                                  "You agree to the collection and use of information in accordance with this Privacy Policy. This "
                                  "Privacy Policy has been created with the help of the Privacy Policy Generator.",
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTextBox(
                              text: "Interpretation and Definitions",
                              fontSize: 17, fontWeight: FontWeight.w800, textAlign: TextAlign.start
                          ),
                        ),
                        _customSizeBox(h: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTermsAndConditions(
                            topic: "Interpretation :",
                            topicFontSize: 15.5,
                            topicFontWeight: FontWeight.w800,
                            description: "The words of which the initial letter is capitalized have meanings defined under the "
                                "following conditions. The following definitions shall have the same meaning regardless of whether "
                                "they appear in singular or in plural. ",
                            boxHeight: 10
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTermsAndConditions(
                            topic: "Definitions :",
                            topicFontSize: 15.5,
                            topicFontWeight: FontWeight.w800,
                            description:
                            "For the purposes of this Privacy Policy:\n"
                            "•  Account means a unique account created for You to access our Service or parts of our Service.\n"
                            "•  Affiliate means an entity that controls, is controlled by or is under common control with a party, where \"control\" means "
                                "ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election "
                                "of directors or other managing authority.\n"
                            "•  Application refers to Start-O-Preneur, the software program provided by the Company.\n"
                            "•  Company (referred to as either \"the Company\", \"We\", \"Us\" or \"Our\" in this Agreement) refers to Nextsavy\n"
                                "Technologies LLP, 507, Phoenix, Navrangpura, Ahmedabad, India.\n"
                            "•  Country refers to: Gujarat,\n"
                            "•  India Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.\n"
                            "•  Personal Data is any information that relates to an identified or identifiable individual.\n"
                            "•  Service refers to the Application.\n"
                            "•  Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to "
                                "third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service "
                                "on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how "
                                "the Service is used.\n"
                            "•  Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service "
                                "infrastructure itself (for example, the duration of a page visit).\n"
                            "•  You means the individual accessing or using the Service, or the company, or other legal entity on behalf "
                                "of which such individual is accessing or using the Service, as applicable.",
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTextBox(
                              text: "Collecting and Using Your Personal Data",
                              fontSize: 17, fontWeight: FontWeight.w800, textAlign: TextAlign.start
                          ),
                        ),
                        _customSizeBox(h: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTextBox(
                              text: "Types of Data Collected",
                              fontSize: 15.5, fontWeight: FontWeight.w800, textAlign: TextAlign.start
                          ),
                        ),
                        _customSizeBox(h: 5),
                        _customTermsAndConditions(
                          topic: "Personal Data :",
                          topicFontSize: 14.5,
                          topicFontWeight: FontWeight.w800,
                          topicTextAlign: TextAlign.left,
                          description:
                          "While using Our Service, We may ask You to provide Us with certain personally identifiable information "
                              "that can be used to contact or identify You. Personally identifiable information may include, but "
                              "is not limited to:\n"
                              "•  Email address\n"
                              "•  First name and last name\n"
                              "•  Usage Data",
                          boxHeight: 10
                         ),
                        _customTermsAndConditions(
                          topic: "Usage Data :",
                          topicFontSize: 14.5,
                          topicFontWeight: FontWeight.w800,
                          topicTextAlign: TextAlign.left,
                          description:
                          "Usage Data is collected automatically when using the Service. Usage Data may include information such "
                              "as Your Device's Internet Protocol address (e.g. IP address), browser type, browser version, the "
                              "pages of our Service that You visit, the time and date of Your visit, the time spent on those pages, "
                              "unique device identifiers and other diagnostic data.\nWhen You access the Service by or through a mobile"
                              " device, We may collect certain information automatically, including, but not limited to, the type of "
                              "mobile device You use, Your mobile device unique ID, the IP address of Your mobile device, Your mobile"
                              " operating system, the type of mobile Internet browser You use, unique device identifiers and other "
                              "diagnostic data.\nWe may also collect information that Your browser sends whenever You visit our "
                              "Service or when You access the Service by or through a mobile device.",
                        ),
                        _customTermsAndConditions(
                          topic: "Use of Your Personal Data: ",
                          description:
                          "•  The Company may use Personal Data for the following purposes:\n"
                          "•  To provide and maintain our Service, including to monitor the usage of our Service.\n"
                          "•  To manage Your Account: to manage Your registration as a user of the Service. The Personal Data You provide "
                            "can give You access to different functionalities of the Service that are available to You as a registered user.\n"
                          "•  For the performance of a contract: the development, compliance and undertaking of the purchase contract for the "
                            "products, items or services You have purchased or of any other contract with Us through the Service.\n"
                          "•  To contact You: To contact You by email, telephone calls, SMS, or other equivalent forms of electronic communication, "
                            "such as a mobile application's push notifications regarding updates or informative communications related "
                            "to the functionalities, products or contracted services, including the security updates, when necessary "
                            "or reasonable for their implementation.\n"
                          "•  To provide You with news, special offers and general information about other goods, services and events "
                              "which we offer that are similar to those that you have already purchased or enquired about unless You "
                              "have opted not to receive such information.\n"
                          "•  To manage Your requests: To attend and manage Your requests to Us.\n"
                          "•  For business transfers: We may use Your information to evaluate or conduct a merger, divestiture, restructuring, "
                              "reorganization, dissolution, or other sale or transfer of some or all of Our assets, whether as a going "
                              "concern or as part of bankruptcy, liquidation, or similar proceeding, in which Personal Data held by Us "
                              "about our Service users is among the assets transferred.\n"
                          "•  For other purposes: We may use Your information for other purposes, such as data analysis, identifying "
                              "usage trends, determining the effectiveness of our promotional campaigns and to evaluate and improve "
                              "our Service, products, services, marketing and your experience.\n\n"
                          "We may share Your personal information in the following situations:\n"
                          "•  With Service Providers: We may share Your personal information with Service Providers to monitor and analyze "
                              "the use of our Service, to contact You.\n"
                          "•  For business transfers: We may share or transfer Your personal information in connection with, or during "
                              "negotiations of, any merger, sale of Company assets, financing, or acquisition of all or a portion of "
                              "Our business to another company.\n"
                          "•  With Affiliates: We may share Your information with Our affiliates, in which case we will require those "
                              "affiliates to honor this Privacy Policy. Affiliates include Our parent company and any other subsidiaries, "
                              "joint venture partners or other companies that We control or that are under common control with Us.\n"
                          "•  With business partners: We may share Your information with Our business partners to offer You certain products, services or promotions."
                          "•  With other users: when You share personal information or otherwise interact in the public areas with other users, "
                              "such information may be viewed by all users and may be publicly distributed outside."
                          "With Your consent: We may disclose Your personal information for any other purpose with Your consent."
                        ),
                        _customTermsAndConditions(
                          topic: "Retention of Your Personal Data",
                          description:
                          "The Company will retain Your Personal Data only for as long as is necessary for the purposes set out in "
                              "this Privacy Policy. We will retain and use Your Personal Data to the extent necessary to comply with "
                              "our legal obligations (for example, if we are required to retain your data to comply with applicable "
                              "laws), resolve disputes, and enforce our legal agreements and policies.\n"
                          "The Company will also retain Usage Data for internal analysis purposes. Usage Data is generally retained "
                              "for a shorter period of time, except when this data is used to strengthen the security or to improve "
                              "the functionality of Our Service, or We are legally obligated to retain this data for longer time periods."
                        ),
                        _customTermsAndConditions(
                          topic: "Transfer of Your Personal Data",
                          description:
                          "Your information, including Personal Data, is processed at the Company's operating offices and in any other "
                              "places where the parties involved in the processing are located. It means that this information may be "
                              "transferred to — and maintained on — computers located outside of Your state, province, country or other "
                              "governmental jurisdiction where the data protection laws may differ than those from Your jurisdiction.\n"
                          "Your consent to this Privacy Policy followed by Your submission of such information represents Your agreement "
                              "to that transfer.\n"
                          "The Company will take all steps reasonably necessary to ensure that Your data is treated securely and in "
                              "accordance with this Privacy Policy and no transfer of Your Personal Data will take place to an organization "
                              "or a country unless there are adequate controls in place including the security of Your data and other"
                              " personal information."
                        ),
                        _customTermsAndConditions(
                          topic: "Delete Your Personal Data",
                          description:
                          "You have the right to delete or request that We assist in deleting the Personal Data that We have collected about You."
                          "Our Service may give You the ability to delete certain information about You from within the Service. You may update, "
                              "amend, or delete Your information at any time by signing in to Your Account, if you have one, and visiting the "
                              "account settings section that allows you to manage Your personal information. You may also contact Us to request "
                              "access to, correct, or delete any personal information that You have provided to Us. Please note, however, "
                              "that We may need to retain certain information when we have a legal obligation or lawful basis to do so."
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTextBox(
                              text: "Disclosure of Your Personal Data",
                              fontSize: 17, fontWeight: FontWeight.w800, textAlign: TextAlign.start
                          ),
                        ),
                        _customSizeBox(h: 5),
                        _customTermsAndConditions(
                          topic: "Business Transactions :",
                          topicFontSize: 15,
                          topicFontWeight: FontWeight.w800,
                          topicTextAlign: TextAlign.left,
                          description:
                          "If the Company is involved in a merger, acquisition or asset sale, Your Personal Data may be transferred. "
                              "We will provide notice before Your Personal Data is transferred and becomes subject to a different "
                              "Privacy Policy.",
                          boxHeight: 10
                        ),
                        _customTermsAndConditions(
                          topic: "Law enforcement :",
                          topicFontSize: 15,
                          topicFontWeight: FontWeight.w800,
                          topicTextAlign: TextAlign.left,
                          description:
                          "Under certain circumstances, the Company may be required to disclose Your Personal Data if required to "
                              "do so by law or in response to valid requests by public authorities (e.g. a court or a government "
                              "agency).",
                          boxHeight: 10
                        ),
                        _customTermsAndConditions(
                            topic: "Other legal requirements :",
                            topicFontSize: 15,
                            topicFontWeight: FontWeight.w800,
                            topicTextAlign: TextAlign.left,
                            description:
                            "The Company may disclose Your Personal Data in the good faith belief that such action is necessary to:\n"
                                "•  Comply with a legal obligation\n"
                                "•  Protect and defend the rights or property of the Company\n"
                                "•  Prevent or investigate possible wrongdoing in connection with the Service\n"
                                "•  Protect the personal safety of Users of the Service or the public\n"
                                "•  Protect against legal liability",
                        ),
                        _customTermsAndConditions(
                            topic: "Security of Your Personal Data",
                            description:
                            "The security of Your Personal Data is important to Us, but remember that no method of transmission "
                                "over the Internet, or method of electronic storage is 100% secure. While We strive to use commercially "
                                "acceptable means to protect Your Personal Data, We cannot guarantee its absolute security.",
                        ),
                        _customTermsAndConditions(
                          topic: "Children's Privacy",
                          description:
                          "Our Service does not address anyone under the age of 13. We do not knowingly collect personally "
                              "identifiable information from anyone under the age of 13. If You are a parent or guardian and "
                              "You are aware that Your child has provided Us with Personal Data, please contact Us. If We become "
                              "aware that We have collected Personal Data from anyone under the age of 13 without verification of "
                              "parental consent, We take steps to remove that information from Our servers.\n"
                          "If We need to rely on consent as a legal basis for processing Your information and Your country requires "
                              "consent from a parent, We may require Your parent's consent before We collect and use that information.",
                        ),
                        _customTermsAndConditions(
                          topic: "Links to Other Websites",
                          description:
                          "Our Service may contain links to other websites that are not operated by Us. If You click on a third "
                              "party link, You will be directed to that third party's site. We strongly advise You to review the "
                              "Privacy Policy of every site You visit. We have no control over and assume no responsibility for "
                              "the content, privacy policies or practices of any third party sites or services.",
                        ),
                        _customTermsAndConditions(
                          topic: "Changes to this Privacy Policy",
                          description:
                          "We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the "
                              "new Privacy Policy on this page. We will let You know via email and/or a prominent notice on Our "
                              "Service, prior to the change becoming effective and update the \"Last updated\" date at the top of "
                              "this Privacy Policy. You are advised to review this Privacy Policy periodically for any changes. "
                              "Changes to this Privacy Policy are effective when they are posted on this page.",
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customTermsAndConditions(
                            topic: "Contact Us",
                            description:
                            "If you have any questions about this Privacy Policy, You can contact us:",
                            boxHeight: 5
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customClickText(
                              context: context,
                              mainFirstText:
                              "•  By email: ",
                              clickText: "support@nextsavy.com",
                              mainLastText: ""),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _customClickText(
                              context: context,
                              mainFirstText:
                              "•  By visiting this page on our website:\n",
                              clickText: "\t\t\t https://www.nextsavy.com/contact/",
                              mainLastText: ""),
                        ),
                        _customSizeBox(h: 35),
                        SizedBox(
                            height: 30,
                            child: Image.asset(
                              AppImages.companyLogo,
                              fit: BoxFit.fitHeight,
                            )
                        ),
                      ],
                    )));
          }
        );
      },
    );
  }

  static Widget _customTermsAndConditions({
    required String topic,
    required String description,
    bool multiple = false,
    String description2 = "",
    double topicFontSize = 17,
    FontWeight topicFontWeight = FontWeight.w800,
    TextAlign topicTextAlign = TextAlign.left,
    double boxHeight = 20
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customTextBox(
          text: topic,
          fontSize: topicFontSize,
          fontWeight: topicFontWeight,
          textAlign: topicTextAlign
        ),
        _customSizeBox(h: 5),
        _customTextBox(
          text: description,
        ),
        if (multiple) ...[
          _customSizeBox(h: 5),
          _customTextBox(
            text: description2,
          ),
        ],
        _customSizeBox(h: boxHeight),
      ],
    );
  }

  static Text _customTextBox(
      {required String text,
        double fontSize = 14,
        FontWeight fontWeight = FontWeight.w600,
        TextAlign textAlign = TextAlign.left}) {
    return Text(
      text,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      textAlign: textAlign,
    );
  }

  static SizedBox _customSizeBox({double h = 10, double w = 0}) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  static Widget _customDivider(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: 50,
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Divider(),
          ),
          _customSizeBox(h: 0, w: 15),
          _customShape(
            boxShape: BoxShape.circle,
          ),
          _customShape(left: 5, right: 5),
          _customShape(boxShape: BoxShape.circle, right: 5),
          _customShape(),
          _customSizeBox(h: 0, w: 15),
          Expanded(
            child: Divider(),
          ),
        ],
      ),
    );
  }

  static Container _customShape(
      {BoxShape boxShape = BoxShape.rectangle, Color borderColor = AppColors.primaryColor, double left = 0, double right = 0}) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.fromLTRB(left, 0, right, 0),
      decoration: BoxDecoration(
          shape: boxShape,
          border: Border.all(
            color: borderColor,
          )),
    );
  }

  static RichText _customClickText(
      {required BuildContext context, required String mainFirstText, required String clickText, required String mainLastText}) {
    Color color = context.isDarkMode ? AppColors.neutralOffWhiteColor : AppColors.darkBackgroundColor;

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        text: mainFirstText,
        style: TextStyle(
          fontFamily: 'Mulish',
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: color,
        ),
        children: <TextSpan>[
          TextSpan(
            text: clickText,
            style: const TextStyle(
              fontFamily: 'Mulish',
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            recognizer: LongPressGestureRecognizer()
              ..onLongPress = () {
                service.Clipboard.setData(service.ClipboardData(text: clickText)).then((_) {
                  _showTextCopiedDialog(context, text: "Copied: $clickText");
                });
                service.HapticFeedback.mediumImpact();
              }
          ),
          TextSpan(
            text: mainLastText,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static void _showTextCopiedDialog(BuildContext context, {required String text}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(
          const Duration(milliseconds: 400), () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        );
        return AlertDialog(
          titlePadding: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          title: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
