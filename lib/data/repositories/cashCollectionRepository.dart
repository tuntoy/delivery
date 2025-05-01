import '../../utils/api.dart';
import '../../utils/constants.dart';
import '../../utils/labelKeys.dart';
import '../models/cashCollection.dart';

class CashCollectionRepository {
  Future<({List<CashCollection> transactions, int total, double balance})>
      getCollections({
    required String status,
    int? offset,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        Api.statusApiKey: status,
        Api.limitApiKey: limit,
        Api.offsetApiKey: offset ?? 0,
      };

      final result = await Api.get(
          url: Api.deliveryBoyCashCollection,
          useAuthToken: true,
          queryParameters: queryParameters);
      return (
        transactions: ((result['data'] ?? []) as List)
            .map((transaction) => CashCollection.fromJson(transaction ?? {}))
            .toList(),
        total: int.parse((result['total'] ?? 0).toString()),
        balance: double.parse((result['balance'] ?? 0).toString()),
      );
    } catch (e) {
      if (e is ApiException) {
        throw ApiException(e.toString());
      } else {
        throw ApiException(defaultErrorMessageKey);
      }
    }
  }
}
