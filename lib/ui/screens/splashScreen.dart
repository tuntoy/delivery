import 'package:prideldelivery/app/routes.dart';
import 'package:prideldelivery/cubits/auth/authCubit.dart';
import 'package:prideldelivery/cubits/settingsAndLanguagesCubit.dart';

import 'package:prideldelivery/ui/widgets/customCircularProgressIndicator.dart';
import 'package:prideldelivery/ui/widgets/error_screen.dart';
import 'package:prideldelivery/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  static Widget getRouteInstance() => const SplashScreen();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    callApi();
  }

  void navigateToNextScreen() async {
    if (context.read<AuthCubit>().state is Unauthenticated) {
      Utils.navigateToScreen(context, Routes.loginScreen, replaceAll: true);
    } else {
      Future.delayed(const Duration(seconds: 2), () {
        Utils.navigateToScreen(context, Routes.mainScreen, replaceAll: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: BlocConsumer<SettingsAndLanguagesCubit, SettingsAndLanguagesState>(
          listener: (context, state) {
        if (state is SettingsAndLanguagesFetchSuccess) {
          navigateToNextScreen();
        } else if (state is SettingsAndLanguagesFetchFailure) {
          Utils.showSnackBar(message: state.errorMessage, context: context);
        }
      }, builder: (context, state) {
        if (state is SettingsAndLanguagesFetchFailure) {
          return ErrorScreen(
            text: state.errorMessage,
            onPressed: callApi,
            child: state is SettingsAndLanguagesFetchInProgress
                ? CustomCircularProgressIndicator(
                    indicatorColor: Theme.of(context).colorScheme.onPrimary,
                  )
                : null,
          );
        }
        if (state is SettingsAndLanguagesFetchSuccess) {
          return Center(
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image(
                    image: AssetImage(Utils.getImagePath('login_bg.png')))),
          );
        }
        return CustomCircularProgressIndicator(
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
        );
      }),
    );
  }

  void callApi() {
    Future.delayed(Duration.zero, () {
      context.read<SettingsAndLanguagesCubit>().fetchSettingsAndLanguages();
    });
  }
}
