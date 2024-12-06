import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend_trend/features/authentication/presentation/pages/custom_textfield.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/config/routes/app_routes.dart';
import 'package:frontend_trend/features/authentication/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:frontend_trend/features/authentication/presentation/pages/custom_button.dart';
import 'package:frontend_trend/features/authentication/presentation/pages/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // If validation passes

      context.read<AuthBloc>().add(LoginEv(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    } else {
      // If validation fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        body: Center(
          child: SizedBox(
            width: 270.w,
            child: Form(
              key: _formKey, // Attach the Form key
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 200.h),
                          Text(
                            'T  R  E  N  D',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          // Username field with validation
                          CustomTextfield(
                            name: 'username',
                            controller: _usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }

                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          // Password field with validation
                          CustomTextfield(
                            name: 'password',
                            controller: _passwordController,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 30.h),
                          CustomButton(
                            text: 'Login',
                            onPressed: () => _validateAndLogin(context),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.go(Routes.forgetPassword);
                              },
                              child: const Text(
                                'Forgot password?',
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          /*Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  'OR',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/icons/google.png',
                                  width: 33.w,
                                  height: 40.h,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/icons/facebook.png',
                                  width: 38.w,
                                  height: 40.h,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/icons/tiktok.png',
                                  width: 38.w,
                                  height: 40.h,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Image.asset(
                                  'assets/icons/instagram.png',
                                  width: 42.w,
                                  height: 40.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),*/
                        ],
                      ),
                    ),
                  ),
                  if (!isKeyboardOpen)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(Routes.signUp);
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!isKeyboardOpen) SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is AuthErrorState) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Logging in...')),
        // );
      } else if (state is AuthLoadingState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logging in...')),
        );
      } else if (state is AuthLoadedState) {
        GoRouter.of(context).go(Routes.initialPage);
      }
    });
  }
}
