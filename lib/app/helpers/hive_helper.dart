import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/models/users/annot_user_model.dart';
import 'package:d818_mobile_app/app/models/users/user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

var log = getLogger('CreateAccountCubit');

class HiveHelper {
  static saveUserDataLocally(UserModel myUserModel) {
    log.w('Saving data to local storage - Hive');
    AnnotatedUserModel myAnnotatedUserModel = AnnotatedUserModel();
    AnnotatedPlan annotatedPlan = AnnotatedPlan();
    annotatedPlan
      ..id = myUserModel.plan?.id
      ..plan = myUserModel.plan?.plan
      ..discount = myUserModel.plan?.discount
      ..planId = myUserModel.plan?.planId
      ..description = myUserModel.plan?.description;

    myAnnotatedUserModel
      ..id = myUserModel.id
      ..fullName = myUserModel.fullName
      ..phone = myUserModel.phone
      ..address = myUserModel.address
      ..email = myUserModel.email
      ..role = myUserModel.role
      ..userModelId = myUserModel.userModelId
      ..token = myUserModel.token
      ..userModelId = myUserModel.userModelId
      ..plan = annotatedPlan;

    log.w('Parsed UserData to be saved: ${myAnnotatedUserModel.toJson()}');
    // Save data to Hive local storage
    final Box userDataBox = Hive.box<AnnotatedUserModel>(Globals.userBox);

    userDataBox.isNotEmpty
        ? userDataBox.putAt(0, myAnnotatedUserModel)
        : userDataBox.add(myAnnotatedUserModel);
  }

  /*

  static saveSettingsConfigLocally(SettingsConfigModel settingsConfigData) {
    log.w('Updating cvNairaValue: ${settingsConfigData.costPerCv} ');
    Globals.cvNairaValue = settingsConfigData.costPerCv!;

    log.w('Saving settings config to local storage - Hive');
    AnnotatedSettingsConfigModel mySettingsConfigData =
        AnnotatedSettingsConfigModel();
    mySettingsConfigData
      ..id = settingsConfigData.id
      ..costPerCv = settingsConfigData.costPerCv
      ..createdAt = settingsConfigData.createdAt
      ..encryptionKey = settingsConfigData.encryptionKey
      ..flutterwavePublicLiveKey = settingsConfigData.flutterwavePublicLiveKey
      ..flutterwavePublicTestKey = settingsConfigData.flutterwavePublicTestKey
      ..flutterwaveSecretLiveKey = settingsConfigData.flutterwaveSecretLiveKey
      ..flutterwaveSecretTestKey = settingsConfigData.flutterwaveSecretTestKey
      ..updatedAt = settingsConfigData.updatedAt
      ..v = settingsConfigData.v;

    log.d('Parsed retrievedConfigData: ${mySettingsConfigData.toJson()}');
    // Save data to Hive local storage
    final Box settingsConfigBox = Hive.box('settingsConfigBox');
    settingsConfigBox.isNotEmpty
        ? settingsConfigBox.putAt(0, mySettingsConfigData)
        : settingsConfigBox.add(mySettingsConfigData);
  }

  static saveWalletDataLocally(MyWalletModel walletData) {
    log.w('Updating myCvBalance: ${walletData.cvp}');
    Globals.myCvBalance = walletData.cvp!;

    log.w('Saving wallet data to local storage - Hive');
    AnnotatedWalletModel myWalletData = AnnotatedWalletModel();
    myWalletData
      ..costPerCv = walletData.costPerCv
      ..cvp = walletData.cvp
      ..cvpWorth = walletData.cvpWorth
      ..earning = walletData.earning
      ..withdrawal = walletData.withdrawal;

    log.d('Parsed Wallet Data: ${myWalletData.toJson()}');
    // Save data to Hive local storage
    final Box savedWalletBox = Hive.box('savedWalletBox');
    savedWalletBox.isNotEmpty
        ? savedWalletBox.putAt(0, myWalletData)
        : savedWalletBox.add(myWalletData);
  }

  static deleteLocalUserData() {
    log.i("Attempting to delete local user data");
    final Box userDataBox = Hive.box('myUserDataBox');
    userDataBox.deleteFromDisk();
  }

  static deleteLocalSettingsData() {
    log.i("Attempting to delete local settings data");
    final Box settingsConfigBox = Hive.box('settingsConfigBox');
    settingsConfigBox.isNotEmpty
        ? settingsConfigBox.deleteFromDisk()
        : log.w("Settings data does not exist locally");
  }

  static deleteLocalWalletData() {
    log.i("Attempting to delete local wallet data");
    final Box savedWalletBox = Hive.box('savedWalletBox');
    savedWalletBox.isNotEmpty
        ? savedWalletBox.deleteFromDisk()
        : log.w("Wallet data does not exist locally");
  }
  */
}
