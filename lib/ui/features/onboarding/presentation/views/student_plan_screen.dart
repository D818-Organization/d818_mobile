import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/widgets/already_have_account_tile.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/widgets/plans_widget.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/curved_container.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('StudentPlansScreen');

class StudentPlansScreen extends StatefulWidget {
  const StudentPlansScreen({super.key});

  @override
  State<StudentPlansScreen> createState() => _StudentPlansScreenState();
}

class _StudentPlansScreenState extends State<StudentPlansScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  goTohHomePage() {
    log.wtf("Going to homepage");
  }

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);
    return GestureDetector(
      onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        body: Padding(
          padding: EdgeInsets.fromLTRB(
            8,
            MediaQuery.of(context).viewPadding.top + 8,
            8,
            8,
          ),
          child: BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 39),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomCurvedContainer(
                        fillColor: AppColors.lighterGrey,
                        height: screenHeight(context) - 100,
                        child: Align(
                          alignment: Alignment.center,
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            children: [
                              Image.asset(
                                'assets/D818.png',
                                height: 70,
                                width: 90,
                              ),
                              Center(
                                child: Text(
                                  "Student Plan",
                                  style: AppStyles.boldHeaderStyle(
                                    16.6,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              customVerticalSpacer(10),
                              Text(
                                "Choose the plan you wish to enrol for.",
                                style: AppStyles.normalStringStyle(
                                  9.0,
                                  color: AppColors.fullBlack,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              customVerticalSpacer(15),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                height: screenHeight(context) - 255,
                                child: Container(
                                  child: state.isLoading == true
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.kPrimaryColor,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : state.isLoading == false &&
                                              state.plans?.isEmpty == true
                                          ? Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Error loading plans!",
                                                    style: AppStyles
                                                        .commonStringStyle(
                                                      14,
                                                      color: AppColors
                                                          .kPrimaryColor,
                                                    ),
                                                  ),
                                                  customVerticalSpacer(20),
                                                  CustomButton(
                                                    width:
                                                        screenWidth(context) *
                                                            0.4,
                                                    height: 45,
                                                    onPressed: () {
                                                      authCubit.getAllPlans();
                                                    },
                                                    child: Text(
                                                      "Retry",
                                                      style: AppStyles
                                                          .coloredSemiHeaderStyle(
                                                        16,
                                                        AppColors.plainWhite,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 0,
                                                vertical: 5,
                                              ),
                                              itemCount: state.plans?.length,
                                              itemBuilder: (context, index) {
                                                return PlanWidget(
                                                  plan: state.plans![index],
                                                );
                                              },
                                            ),
                                ),
                              ),
                              customVerticalSpacer(5),
                              state.showAlreadyHaveAnAccount == false
                                  ? const SizedBox.shrink()
                                  : alreadyHaveAcountTile(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
