import 'package:prideldelivery/app/routes.dart';
import 'package:prideldelivery/cubits/auth/authCubit.dart';
import 'package:prideldelivery/cubits/settingsAndLanguagesCubit.dart';
import 'package:prideldelivery/data/repositories/authRepository.dart';
import 'package:prideldelivery/data/repositories/settingsRepository.dart';
import 'package:prideldelivery/ui/styles/colors.dart';
import 'package:prideldelivery/utils/constants.dart';
import 'package:prideldelivery/utils/hiveBoxKeys.dart';
import 'package:prideldelivery/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubits/user_details_cubit.dart';
import '../firebase_options.dart';
import '../utils/session.dart';

late PackageInfo packageInfo;
late SharedPreferences pref;
late Session session;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  pref = await SharedPreferences.getInstance();
  session = Session(pref);
  packageInfo = await PackageInfo.fromPlatform();

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Hive.initFlutter();
  await Hive.openBox(authBoxKey);
  await Hive.openBox(settingsBoxKey);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsAndLanguagesCubit(SettingsRepository()),
        ),
        BlocProvider(
          create: (context) => AuthCubit(AuthRepository()),
        ),
        BlocProvider<UserDetailsCubit>(create: (_) => UserDetailsCubit()),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<SettingsAndLanguagesCubit,
            SettingsAndLanguagesState>(
          builder: (context, state) {
            final currentLanguage = context
                .watch<SettingsAndLanguagesCubit>()
                .getCurrentAppLanguage();
            return GetMaterialApp(
              navigatorKey: navigatorKey,
              textDirection: currentLanguage.isThisRTL()
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              theme: Theme.of(context).copyWith(
                textTheme:
                    GoogleFonts.rubikTextTheme(Theme.of(context).textTheme),
                scaffoldBackgroundColor: const Color(0xFFF5F8F9),
                shadowColor: const Color(0x3F000000),
                hintColor: secondaryColor.withValues(alpha: 0.67),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                ),
                iconTheme: IconThemeData(color: secondaryColor),
                dividerColor: borderColor.withValues(alpha: 0.4),
                inputDecorationTheme: InputDecorationTheme(
                  iconColor: borderColor.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: borderColor.withValues(alpha: 0.4)),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(borderRadius)),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: borderColor.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(borderRadius)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: errorColor),
                      borderRadius: BorderRadius.circular(borderRadius)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(borderRadius)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                      borderRadius: BorderRadius.circular(borderRadius)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: secondaryColor.withValues(alpha: 0.67)),
                      borderRadius: BorderRadius.circular(borderRadius)),
                ),
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    backgroundColor: Colors.white, elevation: 1),
                colorScheme: ColorScheme.fromSeed(
                  seedColor: primaryColor,
                  primary: primaryColor,
                  primaryContainer: Utils.getColorFromHexValue('#FFFFFF'),
                  secondary: secondaryColor,
                  shadow: const Color(0x3F000000),
                  error: errorColor,
                ),
              ),
              debugShowCheckedModeBanner: false,
              getPages: Routes.getPages,
              initialRoute: Routes.splashScreen,
              routingCallback: (routing) {},
            );
          },
        );
      }),
    );
  }
}

class RouteController extends GetxController {
  var currentRoute = ''.obs;
  var previousRoute = ''.obs;

  @override
  void onInit() {
    ever(currentRoute, (route) {});
    super.onInit();
  }

  void updateCurrentRoute(String route, String previousRoute) {
    currentRoute.value = currentRoute.value;
    currentRoute.value = route;
  }
}
