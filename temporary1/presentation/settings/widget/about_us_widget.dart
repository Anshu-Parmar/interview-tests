import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startopreneur/common/helper/is_dark_mode.dart';
import 'package:startopreneur/core/configs/assets/app_images.dart';
import 'package:startopreneur/core/configs/theme/app_colors.dart';
import 'package:startopreneur/presentation/settings/cubit/change_color_cubit.dart';

class CustomAboutUsModalSheet {
  static final List<IconData> _iconList = [
    Icons.shield_outlined,
    Icons.handshake_outlined,
    Icons.lock_outline,
    Icons.account_tree_outlined
  ];
  static final List<String> _topicList = ["Integrity", "Ownership", "Quality", "Adaptability"];
  static final List<String> _descriptionList = [
    "We express gratitude for others by valuing honesty and openness. Also taking responsibility and accountability for actions, "
        "good and bad.",
    "We have the sense of confidence in your ability to take responsibility. Also being proactive by focusing on bigger picture. "
        "Believing in getting the shit done attitude!",
    "Our requirement analysis is based on customer focus and the total involvement of employees for continuous improvement.",
    "Curiosity is the desire to learn, understand, and know how things work. Also Improvement of communication skills and move "
        "forward with a consistency."
  ];

  static showModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
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
          shouldCloseOnMinExtent: true,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return BlocProvider<ChangeColorCubit>(
              create: (context) => ChangeColorCubit(),
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SingleChildScrollView(
                    controller: scrollController,
                      child: Column(
                    children: [
                      _customTextBox(text: "About Us", fontSize: 24, fontWeight: FontWeight.w700, textAlign: TextAlign.center),
                      _customSizeBox(h: 15),
                      _customTextBox(
                        text: "At Nextsavy Technologies, our core values drive everything we do. We are committed to innovation, "
                                "excellence, and integrity in all our projects.",
                      ),
                      _customDivider(context),
                      AspectRatio(
                        aspectRatio: 0.9,
                        child: BlocBuilder<ChangeColorCubit, bool>(
                          builder: (context, colorState) {
                            return GridView.builder(
                              itemCount: 4,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.9,
                              ),
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) => InkWell(
                                onTap: () {
                                  context.read<ChangeColorCubit>().change(index);
                                  service.HapticFeedback.mediumImpact();
                                },
                                onLongPress: () => service.HapticFeedback.mediumImpact(),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colorState
                                            ? _changeColor(index)
                                            : context.isDarkMode
                                                ? AppColors.lightBackgroundColor
                                                : AppColors.darkBackgroundColor,
                                        width: 1
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _iconList[index],
                                        size: 32,
                                        color: colorState
                                            ? _changeColor(index)
                                            : context.isDarkMode
                                            ? AppColors.lightBackgroundColor
                                            : AppColors.darkBackgroundColor,
                                      ),
                                      _customTextBox(
                                        text: "${index + 1}. ${_topicList[index]}",
                                      ),
                                      _customSizeBox(),
                                      Expanded(
                                          child: _customTextBox(
                                              text: _descriptionList[index],
                                              textAlign: TextAlign.start,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      _customDivider(context),

                      _customAboutUsSections(
                        topic: "Your Path To Digital Excellence Starts Here:",
                        description: "Nextsavy Technologies – Gateway to Digital Excellence. We simplify intricate systems and develop scalable "
                                  "software solutions. With customer-centric values and a skilled team, we’re your trusted partner for "
                                  "digital success."
                      ),
                      _customAboutUsSections(
                          topic: "Trusted Partners in Digital Transformation:",
                          description: "We enhance digital ecosystems and simplify complex systems seamlessly. Our skilled team engineers "
                              "future-ready software solutions, prioritizing customer success. We are here to accelerate your digital "
                              "product’s growth.",
                      ),
                      _customAboutUsSections(
                        topic: "Pioneering Quality-Driven Software Solutions:",
                        description: "Nextsavy Technologies delivers top-notch software solutions. We value best practices, robust architectures, "
                            "and innovation, helping you grow with high-performing, customer-centric software.",
                      ),
                      _customAboutUsSections(
                        topic: "With an unwavering commitment to quality and constant innovation, we aim to exceed expectations and "
                            "deliver exceptional solutions that drive success:",
                        description: "Guided by our core values of integrity and excellence, we strive to empower businesses and shape the "
                            "future of technology. Our mission is to create impactful, long-lasting partnerships by consistently "
                            "delivering value and fostering trust.",
                      ),
                      SizedBox(
                        height: 30,
                        child: Image.asset(
                            AppImages.companyLogo,
                          fit: BoxFit.fitHeight,
                        )
                      ),
                    ],
                  ))),
            );
          }
        );
      },
    );
  }

  static Color _changeColor(int index) {
    switch (index) {
      case 0:
        return Colors.teal;
      case 1:
        return Colors.pink;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blueAccent;
    }
    return Colors.teal;
  }

  static Widget _customAboutUsSections({
    required String topic,
    required String description,
    bool multiple = false,
    String description2 = ""
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customTextBox(text: topic, fontSize: 17, fontWeight: FontWeight.w800, textAlign: TextAlign.start),
        _customTextBox(
          text: description,
        ),
        if (multiple) ...[
          _customSizeBox(h: 5),
          _customTextBox(
            text: description2,
          ),
        ],
        _customSizeBox(h: 20),
      ],
    );
  }

  static SizedBox _customSizeBox({double h = 10, double w = 0}) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  static Text _customTextBox(
      {required String text,
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w600,
      TextAlign textAlign = TextAlign.justify}) {
    return Text(
      text,
      style: TextStyle(fontWeight: fontWeight, fontSize: fontSize),
      textAlign: textAlign,
    );
  }

  static Widget _customDivider(BuildContext context) {

    return SizedBox(
      height: 50,
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
}
