import 'package:intl/intl.dart';

import 'labelKeys.dart';

const String baseUrl = "https://store.pridelcontinental.com";
const String databaseUrl = "$baseUrl/delivery_boy_api/";

const bool isDemoApp = false;

const double appContentHorizontalPadding = 15.0;
double appContentVerticalSpace = 16.0;
double horizontalCompetitionListHeight = 70.0;
double bottomsheetBorderRadius = 15.0;
Duration bottomToastDisplayDuration = const Duration(milliseconds: 3000);
Duration tabBarAnimationDuration = const Duration(milliseconds: 350);
Duration snackBarDuration = const Duration(seconds: 4);
String initialCountryCode = "+91";
const double borderRadius = 4.0;

double bottomBarHeight = 80.0;

DateFormat displayDateFormat = DateFormat('dd-MM-yyyy');
DateFormat apiDateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

const String defaultLanguageCode = 'en';

const appName = 'Pridel Delivery Boy';
//Your package name
const String androidPackageName = 'pridelcontinental.delivery';
const String iosPackageName = 'pridelcontinental.delivery';
//Playstore link of your application
const String androidLink =
    'https://play.google.com/store/apps/details?id=$androidPackageName';

//Appstore link of your application
const String iosLink = 'https://testflight.apple.com/join/SDkT341q';

/// [Api limits constants]
const int limit = 15;
//load items per page in pagination
int loadLimit = 30;
//sessin keys=========
const String pushNotificationSessionKey = 'pushNotification';

String simpleProductType = 'simple_product';
String variableProductType = 'variable_product';
String digitalProductType = 'digital_product';
String physicalProductType = 'physical_product';
const String comboProductType = "combo-product";
const String regularProductType = "regular_product";

const awaitingStatusType = 'awaiting';
const receivedStatusType = 'received';
const processedStatusType = 'processed';
const shippedStatusType = 'shipped';
const deliveredStatusType = 'delivered';
const cancelledStatusType = 'cancelled';
const returnedStatusType = 'returned';
const returnRequestPendingStatusType = 'return_request_pending';
const returnRequestApproveStatusType = 'return_request_approved';
const returnRequestRejectedStatusType = 'return_request_rejected';
const returnPickedupStatusType = 'return_pickedup';

const String keyNotifications = "notificationsKey";
String simpleOrderType = 'simple';
String digitalOrderType = 'digital';
Map<String, String> orderFilterTypes = {
  simpleOrderType: simpleKey,
  digitalOrderType: digitalKey
};
Map<String, String> orderStatusTypes = {
  receivedStatusType: receivedKey,
  processedStatusType: processedKey,
  shippedStatusType: shippedKey,
  deliveredStatusType: deliveredKey,
  cancelledStatusType: cancelledKey,
  returnedStatusType: returnedKey
};
Map<String, String> orderStatusFilter = {"": allKey, ...orderStatusTypes};

String creditType = 'credit';
String debitType = 'debit';

String riderCashType = 'delivery_boy_cash'; // (delivery boy collected)
String cashCollectionType = 'delivery_boy_cash_collection'; // (admin collected)

String percentagePerOrder = 'percentage_per_order_item';
String fixedAmountPerOrder = 'fixed_amount_per_order_item';

Map<String, String> bonusType = {
  percentagePerOrder: percentagePerOrderKey,
  fixedAmountPerOrder: fixedAmountPerOrderKey
};
List<String> imagetypelist = [
  "jpg",
  "jpeg",
  "png",
  "gif",
  "webp",
  "tiff",
  "psd",
  "raw",
  "bmp",
  "heif",
  "indd",
  "jpeg 2000",
  "jfif",
  "exif"
];
