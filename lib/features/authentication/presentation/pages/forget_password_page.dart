import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/features/authentication/presentation/pages/custom_button.dart';
import 'package:frontend_trend/features/authentication/presentation/pages/custom_textfield.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/utils/validation.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _onSend() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context
          .read<AuthBloc>()
          .add(ForgetPasswordEv(email: _emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the keyboard is open
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is AuthLoadedState) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP has been sent to your email")),
        );
        GoRouter.of(context)
            .replace(Routes.checkCode(_emailController.text.trim()));
      } else if (state is AuthLoadingState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Loading ...")),
        );
      }
    }, builder: (context, state) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 270.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Align with LoginPage
                          SizedBox(height: 200.h),

                          SizedBox(height: 30.h),
                          Text(
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          CustomTextfield(
                            name: 'Email Address',
                            isPassword: false,
                            controller: _emailController,
                            validator: (value) =>
                                Validation.validateEmail(value, context),
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            text: 'Send Reset Link',
                            onPressed: () {
                              _onSend();
                            },
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
                // Hide "Back to Login" when the keyboard is open
                if (!isKeyboardOpen)
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        // Navigate back to Login Page
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (!isKeyboardOpen) SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
