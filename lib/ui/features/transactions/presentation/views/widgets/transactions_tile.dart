import 'package:d818_mobile_app/app/models/transactions/outofbounds_orders_model.dart';
import 'package:d818_mobile_app/app/models/transactions/regular_orders_model.dart';
import 'package:d818_mobile_app/ui/shared/shared_res/extensions/string_ext.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegularOrdersTransactionTile extends StatelessWidget {
  final RegularOrdersModel orderData;
  const RegularOrdersTransactionTile({
    super.key,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blueGray,
          radius: 25,
          child: Icon(
            orderData.deliveryStatus.toLowerCase() == "delivered"
                ? CupertinoIcons.check_mark_circled
                : Icons.delivery_dining_outlined,
            color: orderData.deliveryStatus.toLowerCase() == "delivered"
                ? AppColors.normalGreen
                : AppColors.amber,
          ),
        ),
        title: Text(
          orderData.id.toUpperCase(),
          style: AppStyles.semiHeaderStyle(16, 2.0),
        ),
        subtitle: Text(
          DateFormat("MMM d, y h:mma").format(orderData.dateOrdered),
          style: AppStyles.normalStringStyle(12, lineHeight: 2.0),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "-£${orderData.totalPrice}",
              style: AppStyles.semiHeaderStyle(16, 2.0),
            ),
            Text(
              orderData.deliveryStatus.toSentenceCase(),
              style: AppStyles.normalStringStyle(12, lineHeight: 2.0),
            ),
          ],
        ),
      ),
    );
  }
}

class OutOfBoundTransactionTile extends StatelessWidget {
  final OutOfBoundsOrdersModel orderData;
  const OutOfBoundTransactionTile({
    super.key,
    required this.orderData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blueGray,
          radius: 25,
          child: Icon(
            Icons.pedal_bike_sharp,
            color: AppColors.regularBlue,
          ),
        ),
        title: Text(
          orderData.id.toUpperCase(),
          style: AppStyles.semiHeaderStyle(16, 2.0),
        ),
        subtitle: Text(
          DateFormat("MMM d, y h:mma").format(orderData.dateOrdered),
          style: AppStyles.normalStringStyle(12, lineHeight: 2.0),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "-£${orderData.totalPrice}",
              style: AppStyles.semiHeaderStyle(16, 2.0),
            ),
            Text(
              " ",
              style: AppStyles.normalStringStyle(12, lineHeight: 2.0),
            ),
          ],
        ),
      ),
    );
  }
}
