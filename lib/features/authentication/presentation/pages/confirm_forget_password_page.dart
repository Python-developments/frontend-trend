import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/animations/animate_do.dart';
import '../../../../core/utils/toast_utils.dart';
import '../../../../core/utils/validation.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/overlay_loading_page.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class ConfirmForgetPasswordPage extends StatefulWidget {
  const ConfirmForgetPasswordPage({
    super.key,
    required this.email,
    required this.code,
  });
  final String email;
  final String code;

  @override
  State<ConfirmForgetPasswordPage> createState() =>
      _ConfirmForgetPasswordPageState();
}

class _ConfirmForgetPasswordPageState extends State<ConfirmForgetPasswordPage> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ToastUtils(context).showCustomToast(
            message: state.message,
            iconData: Icons.error_outline,
          );
        } else if (state is AuthLoadedState) {
          ToastUtils(context).showCustomToast(
            message: "Password changed successfully".hardcoded,
            iconData: Icons.check_circle_outline,
            durationSeconds: 4,
          );
          GoRouter.of(context).go(Routes.login);
        }
      },
      builder: (context, state) {
        return OverlayLoadingPage(
          isLoading: state is AuthLoadingState,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("Change password".hardcoded),
            ),
            body: _buildForm(),
          ),
        );
      },
    );
  }

  Widget _buildForm() {
    return Container(
      constraints: BoxConstraints(maxWidth: 600.sp),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomFadeInRight(
                child: CustomTextFormField(
                  decoration: InputDecoration(
                    hintText: "New password".hardcoded,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) =>
                      Validation.validatePassword(value, context),
                ),
              ),
              SizedBox(height: 10.sp),
              CustomFadeInLeft(
                child: CustomTextFormField(
                  decoration: InputDecoration(
                    hintText: "Confirm password".hardcoded,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validation.validateConfirmedPassword(
                      _passwordController.text.trim(), value, context),
                ),
              ),
              SizedBox(height: 30.sp),
              CustomFadeInUp(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.sizeOf(context).width, 42),
                    ),
                    onPressed: _onSubmit,
                    child: Text(
                      "Submit".hardcoded,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(ConfirmForgetPasswordEv(
            email: widget.email,
            code: widget.code,
            newPassword: _passwordController.text.trim(),
          ));
    }
  }
}
