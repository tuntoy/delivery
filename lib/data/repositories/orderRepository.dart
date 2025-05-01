import 'package:prideldelivery/utils/constants.dart';

import '../../utils/api.dart';
import '../../utils/labelKeys.dart';

class OrderRepository {
  Future getOrders(Map<String, dynamic> params) async {
    try {
      String url = Api.getOrders;
      if (params.containsKey("active_status") &&
          params["active_status"] == returnedStatusType) {
        url = Api.getReturnedOrderItems;
      }
      final result =
          await Api.get(url: url, useAuthToken: true, queryParameters: params);

      return result;
    } catch (e) {
      if (e is ApiException) {
        throw ApiException(e.toString());
      } else {
        throw ApiException(defaultErrorMessageKey);
      }
    }
  }
}
