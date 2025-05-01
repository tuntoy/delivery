

import '../../utils/api.dart';
import '../../utils/constants.dart';
import '../../utils/labelKeys.dart';
import '../models/transaction.dart';

class TransactionRepository {
  Future<({List<Transaction> transactions, int total, double balance})>
      getTransactions({
    required int userId,
    int? offset,
    String? type,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        Api.limitApiKey: limit,
        Api.offsetApiKey: offset ?? 0,
      };

      final result = await Api.get(
          url: type == debitType
              ? Api.getWithdrawalRequest
              : Api.getTransactions,
          useAuthToken: true,
          queryParameters: queryParameters);
      return (
        transactions: type == debitType
            ? ((result['data'] ?? []) as List)
                .map((transaction) => Transaction.fromWithdrawJson(transaction))
                .toList()
            : ((result['data'] ?? []) as List)
                .map((transaction) => Transaction.fromJson(transaction ?? {}))
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

  Future sendWithdrawalRequest(
      {required Map<String, dynamic> params}) async {
    try {
      final result = await Api.post(
          body: params, url: Api.sendWithdrawalRequest, useAuthToken: true);

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
