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
import '../../../../core/widgets/overlay_loading_page.dart';
import '../../data/models/register_form_data.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _password2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void _onRegister() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(RegisterEv(
              formData: RegisterFormData(
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            fName: _fnameController.text.trim(),
            lName: _lnameController.text.trim(),
          )));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthErrorState) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      } else if (state is AuthLoadedState) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Account has been created, please login.')),
        );

        GoRouter.of(context).go(Routes.login);
      } else if (state is AuthLoadingState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registering new account ...')),
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
                          SizedBox(height: 100.h),
                          Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            'Pick a username for your account. You can always change it later.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.grey,
                            ),
                          ),

                          SizedBox(height: 20.h),
                          CustomTextfield(
                            name: 'Username',
                            isPassword: false,
                            controller: _usernameController,
                            validator: (value) =>
                                Validation.validateUsername(value, context),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextfield(
                            name: 'First Name',
                            isPassword: false,
                            controller: _fnameController,
                            validator: (value) =>
                                Validation.optionalValidation(value, context),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextfield(
                            name: 'Last Name',
                            isPassword: false,
                            controller: _lnameController,
                            validator: (value) =>
                                Validation.optionalValidation(value, context),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextfield(
                            name: 'Email Address',
                            isPassword: false,
                            controller: _emailController,
                            validator: (value) =>
                                Validation.validateEmail(value, context),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextfield(
                            name: 'Password',
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) =>
                                Validation.validatePassword(value, context),
                          ),
                          SizedBox(height: 10.h),
                          CustomTextfield(
                            name: 'Confirm Password',
                            isPassword: true,
                            controller: _password2Controller,
                            validator: (value) =>
                                Validation.validateConfirmedPassword(
                                    _passwordController.text, value, context),
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            text: 'Sign Up',
                            onPressed: () {
                              _onRegister();
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
