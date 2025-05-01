import 'package:prideldelivery/app/app.dart';
import 'package:prideldelivery/data/models/language.dart';
import 'package:prideldelivery/data/models/settings.dart';
import 'package:prideldelivery/data/repositories/settingsRepository.dart';
import 'package:prideldelivery/utils/constants.dart';
import 'package:prideldelivery/utils/defaultLanguageTranslatedValues.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SettingsAndLanguagesState {}

class SettingsAndLanguagesInitial extends SettingsAndLanguagesState {}

class SettingsAndLanguagesFetchInProgress extends SettingsAndLanguagesState {}

class SettingsAndLanguagesFetchSuccess extends SettingsAndLanguagesState {
  final Language currentAppLanguage;
  final List<Language> languages;
  final Settings settings;
  final Map<String, String> currentLanguageTranslatedValues;

  SettingsAndLanguagesFetchSuccess(
      {required this.currentAppLanguage,
      required this.languages,
      required this.settings,
      required this.currentLanguageTranslatedValues});

  SettingsAndLanguagesFetchSuccess copyWith(
      {Language? currentAppLanguage,
      List<Language>? languages,
      Settings? settings,
      Map<String, String>? currentLanguageTranslatedValues}) {
    return SettingsAndLanguagesFetchSuccess(
      currentLanguageTranslatedValues: currentLanguageTranslatedValues ??
          this.currentLanguageTranslatedValues,
      currentAppLanguage: currentAppLanguage ?? this.currentAppLanguage,
      languages: languages ?? this.languages,
      settings: settings ?? this.settings,
    );
  }
}

class SettingsAndLanguagesFetchFailure extends SettingsAndLanguagesState {
  final String errorMessage;

  SettingsAndLanguagesFetchFailure(this.errorMessage);
}

class SettingsAndLanguagesCubit extends Cubit<SettingsAndLanguagesState> {
  final SettingsRepository _settingsRepository;

  SettingsAndLanguagesCubit(this._settingsRepository)
      : super(SettingsAndLanguagesInitial());

  void fetchSettingsAndLanguages() async {
    try {
      emit(SettingsAndLanguagesFetchInProgress());
      List<Language> languages = await _settingsRepository.getLanguages();
      emit(SettingsAndLanguagesFetchSuccess(
          currentAppLanguage: _settingsRepository.getCurrentAppLanguage(),
          languages: languages,
          settings: await _settingsRepository.getSettings(),
          currentLanguageTranslatedValues:
              (_settingsRepository.getCurrentAppLanguage().code != null &&
                      _settingsRepository.getCurrentAppLanguage().code != 'en')
                  ? await _settingsRepository.getLanguageLables(
                      _settingsRepository.getCurrentAppLanguage().code!)
                  : defaultLanguageTranslatedValues));
      if (_settingsRepository.getCurrentAppLanguage().code == null) {
        changeLanguage(languages
            .firstWhere((element) => element.code == defaultLanguageCode));
      }
    } catch (e) {
      emit(SettingsAndLanguagesFetchFailure(e.toString()));
    }
  }

  bool appUnderMaintenance() {
    if (state is SettingsAndLanguagesFetchSuccess) {
      return (state as SettingsAndLanguagesFetchSuccess)
              .settings
              .systemSettings!
              .deliveryBoyAppMaintenanceStatus! ==
          1;
    }
    return false;
  }

  void changeLanguage(Language currentAppLanguage) async {
    _settingsRepository.setCurrentAppLanguage(currentAppLanguage);

    emit((state as SettingsAndLanguagesFetchSuccess).copyWith(
        currentAppLanguage: currentAppLanguage,
        currentLanguageTranslatedValues:
            (_settingsRepository.getCurrentAppLanguage().code != null &&
                    _settingsRepository.getCurrentAppLanguage().code != 'en')
                ? await _settingsRepository.getLanguageLables(
                    _settingsRepository.getCurrentAppLanguage().code!)
                : defaultLanguageTranslatedValues));
  }

  String getTranslatedValue({required String labelKey}) {
    if (state is SettingsAndLanguagesFetchSuccess) {
      return ((state as SettingsAndLanguagesFetchSuccess)
              .currentLanguageTranslatedValues[labelKey]) ??
          (defaultLanguageTranslatedValues[labelKey] ?? labelKey);
    }

    return (defaultLanguageTranslatedValues[labelKey] ?? labelKey);
  }

  Language getCurrentAppLanguage() {
    if (state is SettingsAndLanguagesFetchSuccess) {
      return (state as SettingsAndLanguagesFetchSuccess).currentAppLanguage;
    }
    return Language.fromJson({});
  }

  Settings getSettings() {
    if (state is SettingsAndLanguagesFetchSuccess) {
      return (state as SettingsAndLanguagesFetchSuccess).settings;
    }
    return Settings.fromJson({});
  }

  bool isUpdateRequired() {
    if (state is SettingsAndLanguagesFetchSuccess) {
      if ((state as SettingsAndLanguagesFetchSuccess)
              .settings
              .systemSettings!
              .versionSystemStatus ==
          1) {
        if (defaultTargetPlatform == TargetPlatform.android &&
                needsUpdate((state as SettingsAndLanguagesFetchSuccess)
                    .settings
                    .systemSettings!
                    .currentVersionOfAndroidAppForDeliveryBoy!) ||
            defaultTargetPlatform == TargetPlatform.iOS &&
                needsUpdate((state as SettingsAndLanguagesFetchSuccess)
                    .settings
                    .systemSettings!
                    .currentVersionOfIosAppForDeliveryBoy!)) {
          return true;
        }
      } else {
        return false;
      }
    }
    return false;
  }

  bool needsUpdate(String enforceVersion) {
    final List<int> currentVersion = packageInfo.version
        .split('.')
        .map((String number) => int.parse(number))
        .toList();
    final List<int> enforcedVersion = enforceVersion
        .split('.')
        .map((String number) => int.parse(number))
        .toList();

    for (int i = 0; i < 3; i++) {
      if (enforcedVersion[i] > currentVersion[i]) {
        return true;
      } else if (currentVersion[i] > enforcedVersion[i]) {
        return false;
      }
    }
    return false;
  }

  List<Language> getLanguages() {
    if (state is SettingsAndLanguagesFetchSuccess) {
      return (state as SettingsAndLanguagesFetchSuccess).languages;
    }
    return [];
  }
}
