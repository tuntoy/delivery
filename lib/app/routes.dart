import '../ui/screens/auth/forgotPasswordScreen.dart';
import '../ui/screens/auth/loginScreen.dart';
import '../ui/screens/mainScreen.dart';
import '../ui/screens/profile/policyScreen.dart';
import '../ui/screens/profile/settings/changePasswordScreen.dart';
import '../ui/screens/profile/settings/deleteAccountScreen.dart';
import '../ui/screens/profile/settings/settingScreen.dart';
import '../ui/screens/profile/termsAndPolicyScreen.dart';
import '../ui/screens/splashScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../cubits/auth/sign_up_cubit.dart';
import '../cubits/auth/zoneListCubit.dart';
import '../cubits/order/orderCubit.dart';
import '../cubits/order/orderUpdateCubit.dart';
import '../cubits/order/recentOrderCubit.dart';
import '../data/repositories/orderRepository.dart';
import '../ui/screens/auth/signupScreen.dart';
import '../ui/screens/home/notificationScreen.dart';
import '../ui/screens/orders/orderDetailScreen.dart';
import '../ui/screens/wallet/walletScreen.dart';

class Routes {
  static String splashScreen = "/splash";

  static String loginScreen = "/login";
  static String forgotPasswordScreen = "/forgotPassword";
  static String signupScreen = "/signup";
  static String homeScreen = "/home";
  static String mainScreen = "/";
  static String notificationScreen = "/notifications";
  static String settingScreen = "/settings";
  static String changePasswordScreen = "/changePassword";
  static String deleteAccountScreen = "/deleteAccount";
  static String termsAndPolicyScreen = "/termsAndPolicy";
  static String policyScreen = "/policy";
  static String orderDetailsScreen = "/orderDetails";
  static String walletScreen = "/wallet";

  static final List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen.getRouteInstance()),
    GetPage(name: loginScreen, page: () => LoginScreen.getRouteInstance()),

    GetPage(
        name: forgotPasswordScreen,
        page: () => ForgotPasswordScreen.getRouteInstance()),

    GetPage(
      name: mainScreen,
      page: () => MultiBlocProvider(
        providers: [
          BlocProvider<OrdersCubit>(
            create: (context) => OrdersCubit(OrderRepository()),
          ),
          BlocProvider<RecentOrdersCubit>(
            create: (context) => RecentOrdersCubit(OrderRepository()),
          ),
        ],
        child: MainScreen.getRouteInstance(),
      ),
    ),
    GetPage(
        name: changePasswordScreen,
        page: () => ChangePasswordScreen.getRouteInstance()),
    GetPage(
        name: deleteAccountScreen,
        page: () => DeleteAccountScreen.getRouteInstance()),
    GetPage(
        name: termsAndPolicyScreen,
        page: () => TermsAndPolicyScreen.getRouteInstance()),
    GetPage(
        name: notificationScreen,
        page: () => NotificationScreen.getRouteInstance()),
    GetPage(name: settingScreen, page: () => SettingScreen.getRouteInstance()),
    GetPage(name: policyScreen, page: () => PolicyScreen.getRouteInstance()),
    GetPage(
        name: orderDetailsScreen,
        page: () => BlocProvider<OrderUpdateCubit>(
              create: (context) => OrderUpdateCubit(),
              child: OrderDetailScreen.getRouteInstance(),
            )),
    GetPage(name: walletScreen, page: () => WalletScreen.getRouteInstance()),
    GetPage(
        name: signupScreen,
        page: () => MultiBlocProvider(
              providers: [
                BlocProvider<SignUpCubit>(
                  create: (context) => SignUpCubit(),
                ),
                BlocProvider<ZoneListCubit>(
                  create: (context) => ZoneListCubit(),
                ),
              ],
              child: SignupScreen.getRouteInstance(),
            )),
   
  ];
}
