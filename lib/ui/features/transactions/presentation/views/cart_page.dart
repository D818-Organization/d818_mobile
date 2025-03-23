// ignore_for_file: depend_on_referenced_packages

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/models/campuses/campus_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/presentation/custom_navbar.dart';
import 'package:d818_mobile_app/ui/features/transactions/data/data.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_states.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/geoloc_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/widgets/cart_item_tile.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('CartPage');

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController phoneController = TextEditingController();
  String campusSelectedError = '', addressError = '', phoneNumberError = '';

  gotoLoginScreen() {
    saveScreenToGoAfterLogin('cartPage');
    context.push('/loginScreen');
  }

  checkOutCart(TransactionsBloc transactionsBloc) {
    // Check if selected delivery location is Campus
    if ((selectedDelivery == deliveryList[0]) &&
        (selectedCampusName == campusList[0].name)) {
      setState(() {
        campusSelectedError = 'Kindly select a campus';
      });
    } else {
      setState(() {
        if (campusSelectedError != '') {
          campusSelectedError = '';
        }
      });
    }
    // Check if selected delivery location is City
    if ((selectedDelivery == deliveryList[1]) &&
        (deliveryAddress == null || deliveryAddress == '')) {
      setState(() {
        addressError = 'Kindly fill your delivery address';
      });
    } else {
      setState(() {
        if (addressError != '') {
          addressError = '';
        }
      });
    }
    // Check if phone number is entered
    if (phoneController.text.trim().isEmpty == true ||
        phoneController.text.trim().length < 7) {
      setState(() {
        phoneNumberError = 'Kindly enter a valid phone number';
      });
    } else {
      String phoneNumberEntered = phoneController.text.trim();
      transactionsBloc.add(
        SetDeliveryPhoneNumber(phoneNumberEntered),
      );
      setState(() {
        if (phoneNumberError != '') {
          phoneNumberError = '';
        }
      });
    }
    // If all fields are filled
    if (addressError == '' && phoneNumberError == '') {
      log.w("Going to Checkout Screen");
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      context.push('/checkoutPage');
    }
  }

  initializePhoneNuberField() async {
    final previousPhoneNumber = await getPreviousDeliveryPhoneNumber();
    phoneController = TextEditingController(text: previousPhoneNumber);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TransactionsBloc>(context).add(GetCartData());
    initializePhoneNuberField();
  }

  @override
  Widget build(BuildContext context) {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);

    return ConditionalWillPopScope(
      onWillPop: () async {
        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: BlocBuilder<TransactionsBloc, TransactionsState>(
        bloc: transactionsBloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.plainWhite,
            bottomNavigationBar: const CustomNavBar(currentPageIndx: 2),
            appBar: PreferredSize(
              preferredSize: Size(screenWidth(context), 40),
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).viewPadding.top),
                color: AppColors.plainWhite.withValues(alpha: 0.75),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 10),
                        height: 40,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.fullBlack,
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      "Your Cart",
                      style: AppStyles.boldHeaderStyle(16),
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  customVerticalSpacer(10),
                  _locationSelector(),
                  customVerticalSpacer(10),
                  selectedDelivery == deliveryList[0]
                      ? _campusSelector()
                      : GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeoLocationPage(
                                  previouslySelectedAddress:
                                      deliveryAddress ?? '',
                                ),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            height: 45,
                            width: screenWidth(context),
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              border: Border.all(color: AppColors.lighterGrey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: AppColors.kPrimaryColor,
                                ),
                                customHorizontalSpacer(10),
                                Container(
                                  height: 45,
                                  width: 1,
                                  color: AppColors.lightGrey,
                                ),
                                customHorizontalSpacer(15),
                                Expanded(
                                  child: Text(
                                    deliveryAddress ?? "Enter delivery address",
                                    style: deliveryAddress == null
                                        ? AppStyles.normalStringStyle(16)
                                        : AppStyles.semiHeaderStyle(
                                            16,
                                            1.0,
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  campusSelectedError == ''
                      ? const SizedBox.shrink()
                      : Text(
                          campusSelectedError,
                          style: AppStyles.lightStringStyleColored(
                            12,
                            AppColors.coolRed,
                          ),
                        ),
                  addressError == ''
                      ? const SizedBox.shrink()
                      : Text(
                          addressError,
                          style: AppStyles.lightStringStyleColored(
                            12,
                            AppColors.coolRed,
                          ),
                        ),
                  customHorizontalSpacer(10),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 45,
                    width: screenWidth(context),
                    decoration: BoxDecoration(
                      color: AppColors.transparent,
                      border: Border.all(color: AppColors.lighterGrey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call,
                        ),
                        customHorizontalSpacer(10),
                        Container(
                          height: 45,
                          width: 1,
                          color: AppColors.lightGrey,
                        ),
                        Expanded(
                          child: CustomTextField(
                            textEditingController: phoneController,
                            mainFillColor: AppColors.plainWhite,
                            autofocus: false,
                            height: 36,
                            hintText: "Phone number to call",
                            hintStyle: AppStyles.normalStringStyle(16),
                            inputStringStyle:
                                AppStyles.semiHeaderStyle(16, 1.0),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                  phoneNumberError == ''
                      ? const SizedBox.shrink()
                      : Text(
                          phoneNumberError,
                          style: AppStyles.lightStringStyleColored(
                            12,
                            AppColors.coolRed,
                          ),
                        ),
                  customVerticalSpacer(15),
                  state.loading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : state.noCartItems == true
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                customVerticalSpacer(50),
                                Icon(
                                  CupertinoIcons.cart,
                                  size: 130,
                                  color: AppColors.kPrimaryColor
                                      .withValues(alpha: 0.3),
                                ),
                                Text(
                                  "Cart is empty. Add menu Items",
                                  style: AppStyles.normalStringStyle(
                                    12,
                                    color: AppColors.regularGrey,
                                  ),
                                ),
                              ],
                            )
                          : state.cartData?.products?.isNotEmpty == true
                              ? ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: state.cartData?.products?.length,
                                  itemBuilder: (context, index) {
                                    final mealItemData =
                                        state.cartData!.products![index];
                                    return CartItemTile(
                                      mealData: mealItemData,
                                      indexOfMealProduct: index,
                                      currentQuantity:
                                          mealItemData.quantity ?? 1,
                                    );
                                  },
                                )
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customVerticalSpacer(50),
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: 'Error fetching your cart.  ',
                                          style: AppStyles.lightStringStyle(
                                            14,
                                            color: AppColors.fullBlack,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Reload',
                                              style: AppStyles.headerStyle(
                                                14,
                                                color: AppColors.kPrimaryColor,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    () => transactionsBloc.add(
                                                          GetCartData(),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                  customVerticalSpacer(75),
                ],
              ),
            ),
            floatingActionButton: state.loading == true ||
                    state.cartData?.bill == null ||
                    state.cartData?.bill == 0 ||
                    state.noCartItems == true
                ? const SizedBox.shrink()
                : InkWell(
                    onTap: () {
                      // If user is logged in, go to Checkout, else go to Login
                      if (Globals.token == '') {
                        gotoLoginScreen();
                      } else {
                        checkOutCart(transactionsBloc);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                      width: screenWidth(context) * 0.6,
                      height: 55,
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryColor,
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total: £${state.cartData?.bill ?? 0}",
                            textAlign: TextAlign.center,
                            style: AppStyles.coloredSemiHeaderStyle(
                              18,
                              AppColors.plainWhite,
                            ),
                          ),
                          Text(
                            Globals.token == ''
                                ? "Login to checkout"
                                : "Checkout",
                            textAlign: TextAlign.center,
                            style: AppStyles.coloredSemiHeaderStyle(
                              Globals.token == '' ? 13 : 15,
                              AppColors.plainWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Widget _campusSelector() {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      bloc: transactionsBloc,
      builder: (context, state) {
        return Container(
          height: 45,
          width: screenWidth(context),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(color: AppColors.lighterGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                CupertinoIcons.building_2_fill,
              ),
              customHorizontalSpacer(10),
              SizedBox(
                height: 45,
                width: screenWidth(context) - 115,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      campusList[0].name ?? '',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    style: AppStyles.inputStringStyle(
                        AppColors.fullBlack.withValues(alpha: 0.9)),
                    items: campusList
                        .map(
                          (CampusModel item) => DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(
                              item.name ?? '',
                              style: AppStyles.normalStringStyle(16),
                            ),
                          ),
                        )
                        .toList(),
                    value: selectedCampusName,
                    onChanged: (String? value) {
                      for (var campus in campusList) {
                        if (campus.name == value) {
                          transactionsBloc.add(SelectCampus(campus));
                          log.w(
                              "Selected campus ${campus.name} has id ${campus.id}");
                          break;
                        }
                      }
                      setState(() {
                        selectedCampusName = value;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(height: 35),
                    dropdownStyleData: DropdownStyleData(
                      // maxHeight: screenHeight(context) * 0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      offset: const Offset(0, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: WidgetStateProperty.all(6),
                        thumbVisibility: WidgetStateProperty.all(true),
                      ),
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 30,
                        color: AppColors.fullBlack,
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 55,
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _locationSelector() {
    return Container(
      height: 45,
      width: screenWidth(context),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        border: Border.all(color: AppColors.lighterGrey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.share_location_rounded),
          customHorizontalSpacer(10),
          SizedBox(
            height: 45,
            width: screenWidth(context) - 115,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  deliveryList[0],
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                style: AppStyles.inputStringStyle(
                    AppColors.fullBlack.withValues(alpha: 0.9)),
                items: deliveryList
                    .map(
                      (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: AppStyles.normalStringStyle(16),
                        ),
                      ),
                    )
                    .toList(),
                value: selectedDelivery,
                onChanged: (String? value) {
                  setState(() {
                    selectedDelivery = value;
                  });
                },
                buttonStyleData: const ButtonStyleData(
                  height: 35,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: screenHeight(context) * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: WidgetStateProperty.all(6),
                    thumbVisibility: WidgetStateProperty.all(true),
                  ),
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                    color: AppColors.fullBlack,
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
