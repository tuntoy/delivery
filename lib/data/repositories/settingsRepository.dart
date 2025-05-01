import 'package:prideldelivery/data/models/language.dart';
import 'package:prideldelivery/data/models/settings.dart';
import 'package:prideldelivery/utils/api.dart';
import 'package:prideldelivery/utils/hiveBoxKeys.dart';
import 'package:prideldelivery/utils/labelKeys.dart';

import 'package:hive_flutter/hive_flutter.dart';

class SettingsRepository {
  Future<void> setCurrentAppLanguage(Language value) async {
    try {
      await Hive.box(settingsBoxKey).put(currentAppLanguageKey, value.toJson());
    } catch (e) {}
  }

  Language getCurrentAppLanguage() {
    try {
      final languageValue = Hive.box(settingsBoxKey).get(currentAppLanguageKey);

      return Language.fromJson(Map.from(languageValue ?? {}));
    } catch (e) {
      return Language.fromJson({});
    }
  }

  Future<Settings> getSettings() async {
    try {
      final result = await Api.get(url: Api.getSettings, useAuthToken: true);
      return Settings.fromJson(result);
    } catch (e) {
      if (e is ApiException) {
        throw ApiException(e.toString());
      } else {
        throw ApiException(defaultErrorMessageKey);
      }
    }
  }

  Future<List<Language>> getLanguages() async {
    try {
      final result = await Api.get(url: Api.getLanguages, useAuthToken: false);

      return ((result['data'] ?? []) as List)
          .map((language) => Language.fromJson(language))
          .toList();
    } catch (e) {
      if (e is ApiException) {
        throw ApiException(e.toString());
      } else {
        throw ApiException(defaultErrorMessageKey);
      }
    }
  }

  Future<Map<String, String>> getLanguageLables(String languageCode) async {
    try {
      final result = await Api.get(
          url: Api.getLanguageLabels,
          queryParameters: {Api.languageCodeApiKey: languageCode},
          useAuthToken: false);

      return Map.from(result['data'] ?? {});
    } catch (e) {
      if (e is ApiException) {
        throw ApiException(e.toString());
      } else {
        throw ApiException(defaultErrorMessageKey);
      }
    }
  }
}
