// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/models/transactions/outofbounds_orders_model.dart';
import 'package:d818_mobile_app/app/models/transactions/regular_orders_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_states.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/widgets/transactions_tile.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('TransactionsPage');

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    BlocProvider.of<TransactionsBloc>(context).add(FetchAllOrdersData());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);

    return BlocBuilder<TransactionsBloc, TransactionsState>(
      bloc: transactionsBloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            body: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: AppColors.plainWhite,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.fullBlack,
                    ),
                  ),
                  title: Text(
                    "Transactions",
                    style: AppStyles.coloredSemiHeaderStyle(
                        16, AppColors.fullBlack),
                  ),
                  bottom: state.loading == true
                      ? PreferredSize(
                          preferredSize: Size(screenWidth(context), 10),
                          child: const SizedBox.shrink(),
                        )
                      : TabBar(
                          indicatorColor: AppColors.coolRed,
                          tabs: [
                            Tab(
                              icon: Text(
                                "Regular Orders",
                                style: AppStyles.coloredSemiHeaderStyle(
                                  14,
                                  AppColors.fullBlack,
                                ),
                              ),
                            ),
                            Tab(
                              icon: Text(
                                "Out of Bound Orders",
                                style: AppStyles.coloredSemiHeaderStyle(
                                  14,
                                  AppColors.fullBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                //
                body: state.loading == true
                    ? const Center(
                        child: CircularProgressIndicator(strokeWidth: 3),
                      )
                    : TabBarView(
                        children: [
                          state.noRegOrdersItems == true
                              ? Center(
                                  child: Text(
                                    "You have no orders yet!",
                                    style: AppStyles.lightStringStyleColored(
                                      13,
                                      AppColors.fullBlack,
                                    ),
                                  ),
                                )
                              : state.errorFetchingOrders == true ||
                                      state.regularOrdersData == null
                                  ? Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: AppColors.coolRed,
                                          ),
                                          Text(
                                            "Error fetching your orders! ",
                                            style: AppStyles
                                                .lightStringStyleColored(
                                              13,
                                              AppColors.coolRed,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => transactionsBloc
                                                .add(FetchAllOrdersData()),
                                            child: Text(
                                              "Retry",
                                              style: AppStyles.boldHeaderStyle(
                                                13,
                                                color: AppColors.coolRed,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : regularOrdersView(
                                      state.regularOrdersData!,
                                    ),
                          state.noOobOrdersItems == true
                              ? Center(
                                  child: Text(
                                    "You have no orders yet!",
                                    style: AppStyles.lightStringStyleColored(
                                      13,
                                      AppColors.fullBlack,
                                    ),
                                  ),
                                )
                              : state.errorFetchingOrders == true ||
                                      state.outOfBoundOrdersData == null
                                  ? Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline_rounded,
                                            color: AppColors.coolRed,
                                          ),
                                          Text(
                                            "Error fetching your orders! ",
                                            style: AppStyles
                                                .lightStringStyleColored(
                                              13,
                                              AppColors.coolRed,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => transactionsBloc
                                                .add(FetchAllOrdersData()),
                                            child: Text(
                                              "Retry",
                                              style: AppStyles.boldHeaderStyle(
                                                13,
                                                color: AppColors.coolRed,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : outOfBoundsOrdersView(
                                      state.outOfBoundOrdersData!,
                                    )
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget regularOrdersView(List<RegularOrdersModel> ordersList) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: ordersList.length,
      itemBuilder: (context, index) => RegularOrdersTransactionTile(
        orderData: ordersList[index],
      ),
    );
  }

  Widget outOfBoundsOrdersView(List<OutOfBoundsOrdersModel> ordersList) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: ordersList.length,
      itemBuilder: (context, index) => OutOfBoundTransactionTile(
        orderData: ordersList[index],
      ),
    );
  }
}
