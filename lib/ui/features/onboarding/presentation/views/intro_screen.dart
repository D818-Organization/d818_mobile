import 'package:carousel_slider/carousel_slider.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('IntroScreen');

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final Color kDarkBlueColor = const Color(0xFF053149);

  bool atLastSlide = false;

  final List<String> imagePaths = [
    'assets/order.png',
    'assets/delivery.png',
    'assets/courier.png',
  ];

  final List<String> headers = [
    'Easy To Order',
    'Fastest Delivery',
    'Best Quality',
  ];

  final List<String> captions = [
    "Order your meals with ease.",
    "The delivery is timely and prompt.",
    "We deliver the best there is."
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  void nextSlide() {
    carouselController.nextPage();
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plainWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customVerticalSpacer(25),
          Center(
            child: SizedBox(
              height: 450,
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: imagePaths.length,
                itemBuilder: (BuildContext context, index, int realIndex) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        imagePaths[index],
                        height: 245,
                        width: 245,
                      ),
                      customVerticalSpacer(42),
                      Text(
                        headers[index],
                        style: AppStyles.headerStyle(25),
                      ),
                      customVerticalSpacer(30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          captions[index],
                          textAlign: TextAlign.center,
                          style: AppStyles.commonStringStyle(
                            18.75,
                            color: AppColors.fullBlack,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                  height: 450,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      if (index == imagePaths.length - 1) {
                        atLastSlide = true;
                        currentIndex = index;
                      } else {
                        atLastSlide = false;
                        currentIndex = index;
                      }
                    });
                  },
                ),
              ),
            ),
          ),
          customVerticalSpacer(15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imagePaths.map((url) {
              int index = imagePaths.indexOf(url);
              return Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? AppColors.kPrimaryColor
                      : AppColors.plainWhite,
                  border: Border.all(
                    color: currentIndex == index
                        ? AppColors.kPrimaryColor
                        : AppColors.lightGrey,
                  ),
                ),
              );
            }).toList(),
          ),
          customVerticalSpacer(40),
          CustomButton(
            width: screenWidth(context) - 120,
            borderRadius: 15,
            child: Text(
              atLastSlide ? AppStrings.proceed : AppStrings.contineu,
              style: AppStyles.commonStringStyle(18.75),
            ),
            onPressed: () {
              if (atLastSlide == true) {
                log.w("To next screen");
                context.go('/homePage');
              } else {
                log.w("Next slide");
                nextSlide();
              }
            },
          ),
          customVerticalSpacer(15),
          atLastSlide == true
              ? customVerticalSpacer(45)
              : SizedBox(
                  height: 45,
                  child: TextButton(
                    onPressed: () {
                      log.wtf("Skip pressed");
                      // carouselController.animateToPage(2);
                      context.go('/homePage');
                    },
                    child: Text(
                      AppStrings.skip,
                      style: AppStyles.normalStringStyle(
                        18.75,
                        color: AppColors.fullBlack,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
