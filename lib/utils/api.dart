import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:prideldelivery/data/repositories/authRepository.dart';
import 'package:prideldelivery/data/repositories/settingsRepository.dart';
import 'package:prideldelivery/utils/constants.dart';
import 'package:prideldelivery/utils/defaultLanguageTranslatedValues.dart';
import 'package:prideldelivery/utils/labelKeys.dart';

import '../app/app.dart';
import '../app/routes.dart';
import '../ui/widgets/check_interconnectiviy.dart';
import 'utils.dart';

class ApiException implements Exception {
  String errorMessage;
  final List<Map<String, dynamic>>? errorData;
  final int? errorCode;

  ApiException(this.errorMessage, {this.errorData, this.errorCode});

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  static String register = "${databaseUrl}register";
  static String login = "${databaseUrl}login";
  static String verifyUser = "${databaseUrl}verify_user";
  static String getUserDetails = "${databaseUrl}get_delivery_boy_details";
  static String updateOrderItemStatus =
      "${databaseUrl}update_order_item_status"; //
  static String resetPassword = "${databaseUrl}reset_password";
  static String updateFcm = "${databaseUrl}update_fcm";
  static String getSettings = "${databaseUrl}get_settings";
  static String getLanguages = "${databaseUrl}get_languages";
  static String getLanguageLabels = "${databaseUrl}get_language_labels";
  static String getOrders = "${databaseUrl}get_orders";
  static String getTransactions = "${databaseUrl}get_wallet_transaction";
  static String getWithdrawalRequest = "${databaseUrl}get_withdrawal_request";
  static String sendWithdrawalRequest = "${databaseUrl}send_withdrawal_request";
  static String deleteUserAccount = "${databaseUrl}delete_delivery_boy";
  static String updateUser = "${databaseUrl}update_user";
  static String deliveryBoyCashCollection =
      "${databaseUrl}get_delivery_boy_cash_collection";
  static String getZipcodes = "${databaseUrl}get_zipcodes";
  static String getCities = "${databaseUrl}get_cities";
  static String getNotifications = "${databaseUrl}get_notifications";
  static String getProducts = "${databaseUrl}get_products";
  static String getComboProducts = "${databaseUrl}get_combo_products";
  static String addPickupLocation = "${databaseUrl}add_pickup_location";
  static String getPickupLocation = "${databaseUrl}get_pickup_locations";
  static String getSalesList = "${databaseUrl}get_sales_list";
  static String getBrandList = "${databaseUrl}get_brand_list";
  static String getCategoryList = "${databaseUrl}get_categories";
  static String getCountryData = "${databaseUrl}get_countries_data";
  static String getTaxes = "${databaseUrl}get_taxes";
  static String getProductFaqs = "${databaseUrl}get_product_faqs";
  static String addProductFaqs = "${databaseUrl}add_product_faqs";
  static String editProductFaqs = "${databaseUrl}edit_product_faq";
  static String deleteProduct = "${databaseUrl}delete_product";
  static String deleteComboProduct = "${databaseUrl}delete_combo_product";
  static String updateProductStatus = "${databaseUrl}update_product_status";
  static String getProductRating = "${databaseUrl}get_product_rating";
  static String getComboProductRating =
      "${databaseUrl}get_combo_product_rating";
  static String manageStock = "${databaseUrl}manage_stock";
  static String chatifyAuthAPI = '$baseUrl/chatify/api/chat/auth';
  static String chatifySendMessageApi = '$baseUrl/chatify/api/sendMessage';
  static String chatifyFetchMessagesApi = '$baseUrl/chatify/api/fetchMessages';
  static String chatifySearchApi = '$baseUrl/chatify/api/search';
  static String chatifyGetContactsApi = '$baseUrl/chatify/api/getContacts';
  static String chatifyMakeSeenApi = '$baseUrl/chatify/api/makeSeen';
  static String getAttributes = "${databaseUrl}get_attributes";
  static String getMedia = "${databaseUrl}get_media";
  static String getTotalData = "${databaseUrl}get_total_data";
  static String topSellingProducts = "${databaseUrl}top_selling_products";
  static String mostSellingCategories = "${databaseUrl}most_selling_categories";
  static String getOverviewStatistic = "${databaseUrl}get_overview_statistic";
  static String uploadMedia = "${databaseUrl}upload_media";
  static String addProducts = "${databaseUrl}add_products";
  static String addSellerStore = "${databaseUrl}add_seller_store";
  static String getZones = "${databaseUrl}get_zones";
  static String updateReturnedOrderItemStatus =
      "${databaseUrl}update_returned_order_item_status";
  static String getReturnedOrderItems =
      "${databaseUrl}get_returned_order_items";

  ///=====*** form keys=====
  static String passwordApiKey = 'password';
  static String mobileApiKey = 'mobile';
  static String newApiKey = 'new';
  static String oldApiKey = 'old';
  static String fcmIdApiKey = 'fcm_id';
  static String userIdApiKey = 'user_id';
  static String offsetApiKey = 'offset';
  static String limitApiKey = 'limit';
  static String sortByApiKey = 'sort';
  static String typeApiKey = 'type';
  static String storeIdApiKey = 'store_id';
  static String amountApiKey = 'amount';
  static String paymentAddressApiKey = 'payment_address';
  static String showOnlyStockProductApiKey = 'show_only_stock_product';
  static String productIdApiKey = 'product_id';
  static String searchApiKey = 'search';
  static String questionApiKey = 'question';
  static String answerApiKey = 'answer';
  static String productTypeApiKey = 'product_type';
  static String editIdApiKey = 'edit_id';
  static String orderByApiKey = 'order';
  static String topRatedProductApiKey = 'top_rated_product';
  static String discountApiKey = 'discount';
  static String flagApiKey = 'flag';
  static String ratingApiKey = 'rating';
  static String statusApiKey = 'status';
  static String idApiKey = 'id';
  static String fromIdApiKey = 'from_id';
  static String toIdApiKey = 'to_id';
  static String fileApiKey = 'file';
  static String messageApiKey = 'message';
  static String productVariantIdApiKey = 'product_variant_id';
  static String quantityApiKey = 'quantity';
  static String currentStockApiKey = 'current_stock';
  static String categoryIdApiKey = 'category_id';
  static String mobileNoApiKey = 'mobile_no';
  static String isNotificationOnApiKey = 'is_notification_on';
  static String languageCodeApiKey = 'language_code';

  static Map<String, dynamic> headers() {
    String jwtToken = AuthRepository.getToken();
    if (jwtToken.isEmpty) {
      return {};
    }

    return {
      "Authorization": "Bearer $jwtToken",
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  static printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) {});
  }

  static callOnUnauthorized(
    String url, {
    String? message,
  }) {
    if ([Api.verifyUser, Api.login, Api.updateFcm, Api.updateUser]
        .contains(url)) {
      Utils.showSnackBar(
          message: 'Unauthenticated. Please login again.',
          context: navigatorKey.currentContext!);
      Utils.navigateToScreen(navigatorKey.currentContext!, Routes.loginScreen,
          replaceAll: true);
    }
  }

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw ApiException(noInternetKey);
      }
      final Dio dio = Dio();
      final FormData formData =
          FormData.fromMap(body, ListFormat.multiCompatible);

      final response = await dio.post(url,
          data: formData,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          options: useAuthToken ? Options(headers: headers()) : null);

      if ([
        Api.chatifyFetchMessagesApi,
        Api.chatifySendMessageApi,
        Api.chatifyMakeSeenApi
      ].contains(url)) {
        return Map.from(response.data);
      }
      if (url == Api.chatifyAuthAPI) {
        return jsonDecode(response.data);
      }
      if (response.data['error']) {
        if (response.data['code'] == 401) {
          callOnUnauthorized(url);
        }
        throw ApiException(
          SettingsRepository().getCurrentAppLanguage().code != null &&
                  SettingsRepository().getCurrentAppLanguage().code != 'en'
              ? response.data['language_message_key'] ??
                  response.data['message']
              : response.data['message'].toString(),
          errorCode: response.data['code'],
        );
      }
      if (SettingsRepository().getCurrentAppLanguage().code != null &&
          SettingsRepository().getCurrentAppLanguage().code != 'en') {
        response.data['message'] = response.data['language_message_key'];
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        if (e.response!.statusCode == 500) {
          // Handle the 500 error
          throw ApiException(internalServerErrorMessageKey);
        }
        if (e.response!.statusCode == 401) {
          // Handle the 401 error
          callOnUnauthorized(url, message: e.response!.data['message']);
        }
      } else {
        // Something happened in setting up the request or an error occurred before the response
        throw ApiException(e.error is SocketException
            ? noInternetKey
            : e.response?.data['message']);
      }

      throw ApiException(e.error is SocketException
          ? noInternetKey
          : e.response?.data['message']);
      //throw ApiException(e.error is SocketException ? noInternetKey: e.response?.data['message']);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage, errorCode: e.errorCode);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static errMsg(var getdata) {
    Map map = getdata;

    if (!map.containsKey("data") && !map.containsKey("message")) {
      return;
    }

    if (map.containsKey("data")) {
      if (map['data'].runtimeType == List && (map['data'] as List).isEmpty) {
        return map['messge'];
      }
      Map data = getdata['data'];
      if (data.containsKey('errors')) {
        return getApiMessage(data['errors']);
      } else if (getdata.containsKey('message')) {
        return getdata['message'];
      } else {
        return defaultErrorMessageKey;
      }
    } else if (map.containsKey("message")) {
      return map['message'];
    } else {
      return defaultErrorMessageKey;
    }
  }

  static String getApiMessage(var message, {bool withkey = false}) {
    String apimsg = '';
    if (message is String) {
      return apimsg = message;
    } else {
      message.forEach((k, v) {
        if (v is List<dynamic>) {
          apimsg = "$apimsg${withkey ? "$k: " : ""}${v.first}\n";
        } else {
          apimsg = "${apimsg + (withkey ? "$k: " : "") + v}\n";
        }
      });
    }
    return apimsg;
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw ApiException(noInternetKey);
      }

      final Dio dio = Dio(
        BaseOptions(
          baseUrl: databaseUrl,
          headers: headers(),
          contentType: 'application/json',
        ),
      );
      final response = await dio.get(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);

      if ([
        Api.getProductRating,
        Api.chatifySearchApi,
        Api.chatifyGetContactsApi
      ].contains(url)) {
        return Map.from(response.data);
      }
      if (url == Api.getLanguageLabels) {
        return defaultLanguageTranslatedValues;
      }
      if (response.data['error']) {
        if (response.data['code'] == 401) {
          callOnUnauthorized(url);
        }
        throw ApiException(SettingsRepository().getCurrentAppLanguage().code !=
                    null &&
                SettingsRepository().getCurrentAppLanguage().code != 'en'
            ? response.data['language_message_key'] ?? response.data['message']
            : response
                .data['message']); // response.data['message'].toString());
      }
      if (SettingsRepository().getCurrentAppLanguage().code != null &&
          SettingsRepository().getCurrentAppLanguage().code != 'en') {
        response.data['message'] = response.data['language_message_key'];
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        if (e.response!.statusCode == 500) {
          // Handle the 500 error
          throw ApiException(internalServerErrorMessageKey);
        }
        if (e.response!.statusCode == 401) {
          // Handle the 401 error
          callOnUnauthorized(url, message: e.response!.data['message']);
        }
      }

      throw ApiException(
          e.error is SocketException ? noInternetKey : defaultErrorMessageKey);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage, errorCode: e.errorCode);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> put({
    Map<String, dynamic>? body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw const SocketException(noInternetKey);
      }
      final Dio dio = Dio();
      final FormData formData =
          FormData.fromMap(body ?? {}, ListFormat.multiCompatible);
      final response = await dio.put(url,
          data: formData,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          options: useAuthToken ? Options(headers: headers()) : null);
      if (response.data['error']) {
        if (response.data['code'] == 401) {
          callOnUnauthorized(url);
        }
        throw ApiException(SettingsRepository().getCurrentAppLanguage().code !=
                    null &&
                SettingsRepository().getCurrentAppLanguage().code != 'en'
            ? response.data['language_message_key'] ?? response.data['message']
            : response.data['message']); //response.data['message'].toString());
      }
      if (SettingsRepository().getCurrentAppLanguage().code != null &&
          SettingsRepository().getCurrentAppLanguage().code != 'en') {
        response.data['message'] =
            response.data['language_message_key'] ?? response.data['message'];
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        if (e.response!.statusCode == 500) {
          // Handle the 500 error
          throw ApiException(internalServerErrorMessageKey);
        }
        if (e.response!.statusCode == 401) {
          // Handle the 401 error
          callOnUnauthorized(url, message: e.response!.data['message']);
        }
      }

      throw ApiException(e.error is SocketException
          ? noInternetKey
          : e.response?.data['message']);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> delete({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw ApiException(noInternetKey);
      }
      final Dio dio = Dio();

      final response = await dio.delete(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);
      if (response.data['error']) {
        if (response.data['code'] == 401) {
          callOnUnauthorized(url);
        }
        throw ApiException(SettingsRepository().getCurrentAppLanguage().code !=
                    null &&
                SettingsRepository().getCurrentAppLanguage().code != 'en'
            ? response.data['language_message_key'] ?? response.data['message']
            : response
                .data['message']); // response.data['message'].toString());
      }
      if (SettingsRepository().getCurrentAppLanguage().code != null &&
          SettingsRepository().getCurrentAppLanguage().code != 'en') {
        response.data['message'] = response.data['language_message_key'];
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        if (e.response!.statusCode == 500) {
          // Handle the 500 error
          throw ApiException(internalServerErrorMessageKey);
        }
        if (e.response!.statusCode == 401) {
          // Handle the 401 error
          callOnUnauthorized(url, message: e.response!.data['message']);
        }
      }

      throw ApiException(e.error is SocketException
          ? noInternetKey
          : e.response?.data['message']);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static Future<void> download(
      {required String url,
      required CancelToken cancelToken,
      required String savePath,
      required Function updateDownloadedPercentage}) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw const SocketException(noInternetKey);
      }
      final Dio dio = Dio();
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: ((count, total) {
        updateDownloadedPercentage((count / total) * 100);
      }));
    } on DioException catch (e) {
      throw ApiException(
          e.error is SocketException ? noInternetKey : defaultErrorMessageKey);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }

  static Future<String> getHtmlContent({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (await InternetConnectivity.isUserOffline()) {
        throw ApiException(noInternetKey);
      }

      //
      final Dio dio = Dio();
      final response = await dio.get(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        if (e.response!.statusCode == 500) {
          // Handle the 500 error
          throw ApiException(internalServerErrorMessageKey);
        }
        if (e.response!.statusCode == 401) {
          // Handle the 401 error
          callOnUnauthorized(url, message: e.response!.data['message']);
        }
      }

      throw ApiException(e.error is SocketException
          ? noInternetKey
          : e.response?.data['message']);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(defaultErrorMessageKey);
    }
  }
}
