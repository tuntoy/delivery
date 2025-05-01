import 'package:country_code_picker/country_code_picker.dart';
import 'package:prideldelivery/cubits/auth/resetPasswordCubit.dart';
import 'package:prideldelivery/ui/screens/auth/widgets/loginContainer.dart';
import 'package:prideldelivery/ui/widgets/customCircularProgressIndicator.dart';
import 'package:prideldelivery/utils/api.dart';
import 'package:prideldelivery/utils/constants.dart';
import 'package:prideldelivery/utils/labelKeys.dart';
import 'package:prideldelivery/utils/validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../utils/utils.dart';
import '../../widgets/customTextFieldContainer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);
  static Widget getRouteInstance() => BlocProvider(
        create: (context) => ResetPasswordCubit(),
        child: const ForgotPasswordScreen(),
      );
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Utils.showSnackBar(message: state.successMessage, context: context);
          Utils.navigateToScreen(context, Routes.loginScreen);
        } else if (state is ResetPasswordFailure) {
          Utils.showSnackBar(message: state.errorMessage, context: context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: LoginContainer(
            titleText: forgotPasswordTitleKey,
            descriptionText: weWillSendVerificationCodeToKey,
            buttonText: resetPasswordKey,
            buttonWidget: state is ResetPasswordInProgress
                ? const CustomCircularProgressIndicator()
                : null,
            onTapButton: state is ResetPasswordInProgress ? () {} : callApi,
            content: buildContent(),
          ),
        );
      },
    );
  }

  callApi() {
    FocusScope.of(context).unfocus();

    if (_mobileController.text.isNotEmpty) {
      {
        if (isDemoApp) {
          Utils.showSnackBar(message: demoModeOnKey, context: context);
          return;
        }
        context.read<ResetPasswordCubit>().resetPassword(params: {
          Api.mobileNoApiKey: _mobileController.text.trim(),
        });
      }
    } else {
      Utils.showSnackBar(message: enterValidMobileNumberKey, context: context);
    }
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsetsDirectional.only(
                    end: 0.0, bottom: 5.0, top: 0, start: 0),
                margin: const EdgeInsets.only(right: 5),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: 1,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                child: CountryCodePicker(
                  onChanged: (countryCode) {},
                  flagWidth: 25,
                  padding: const EdgeInsets.all(0),
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: initialCountryCode,
                  // favorite: const ['+91', 'IN'],
                  showFlagDialog: true,
                  comparator: (a, b) => b.name!.compareTo(a.name!),
                  //Get the country information relevant to the initial selection
                  onInit: (code) {},
                  alignLeft: true,
                ),
              )),
          Expanded(
            flex: 2,
            child: CustomTextFieldContainer(
              hintTextKey: mobileNumberKey,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              textEditingController: _mobileController,
              labelKey: '',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Allow only digits
                LengthLimitingTextInputFormatter(15), // Limit to 15 digits
              ],
              validator: (v) => Validator.validatePhoneNumber(v, context),
              suffixWidget: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => _mobileController.clear(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
