import 'package:d818_mobile_app/app/models/meals/plans_model.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/cubits/auth_cubit.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/bloc/states/auth_state.dart';
import 'package:d818_mobile_app/ui/features/onboarding/presentation/views/widgets/text_tile.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/curved_container.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_strings.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlanWidget extends StatefulWidget {
  const PlanWidget({super.key, required this.plan});

  final PlansModel? plan;

  @override
  State<PlanWidget> createState() => _PlanWidgetState();
}

class _PlanWidgetState extends State<PlanWidget> {
  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = BlocProvider.of<AuthCubit>(context);

    return BlocBuilder<AuthCubit, AuthState>(
        bloc: authCubit,
        builder: (context, state) {
          return CustomCurvedContainer(
            height: 250,
            fillColor: AppColors.plainWhite,
            child: Column(
              children: [
                customVerticalSpacer(14),
                Text(
                  "${widget.plan?.plan}",
                  style: AppStyles.boldHeaderStyle(11.76),
                ),
                customVerticalSpacer(19),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                      itemCount: widget.plan?.description?.length,
                      itemBuilder: (context, index) {
                        return textTile(
                          "${widget.plan?.description?[index]}",
                          width: screenWidth(context) * 0.4,
                        );
                      },
                    ),
                  ),
                ),
                CustomButton(
                  // Create Account for this user
                  onPressed: () {
                    authCubit.createStudentAccount(
                      context,
                      planId: widget.plan!.id!,
                    );
                  },
                  width: 80,
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.enroll,
                        style: AppStyles.coloredSemiHeaderStyle(
                          12.345,
                          AppColors.plainWhite,
                        ),
                      ),
                      customHorizontalSpacer(
                          state.isProcessing == true ? 10 : 0),
                      state.isProcessing == true
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.plainWhite,
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                customVerticalSpacer(5),
              ],
            ),
          );
        });
  }
}
