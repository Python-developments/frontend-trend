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
import '../../../../core/widgets/labeled_widget.dart';
import '../../../../core/widgets/overlay_loading_page.dart';
import '../bloc/auth_bloc/auth_bloc.dart';

class CheckCodePage extends StatefulWidget {
  const CheckCodePage({super.key, required this.email});
  final String email;
  @override
  State<CheckCodePage> createState() => _CheckCodePageState();
}

class _CheckCodePageState extends State<CheckCodePage> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ToastUtils(context).showCustomToast(message: state.message);
        } else if (state is AuthLoadedState) {
          GoRouter.of(context).replace(Routes.confirmForgetPassword(
              widget.email, _codeController.text.trim()));
        }
      },
      builder: (context, state) {
        return OverlayLoadingPage(
          isLoading: state is AuthLoadingState,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text("Forget password".hardcoded),
            ),
            body: _buildFormWidget(context),
          ),
        );
      },
    );
  }

  SingleChildScrollView _buildFormWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.sp),
      child: Container(
        constraints: BoxConstraints(maxWidth: 500.sp),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Please check your mail inbox for confirmation code".hardcoded,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).textTheme.displayLarge!.color),
              ),
              SizedBox(height: 10.sp),
              LabeledWidget(
                title: "Email".hardcoded,
                child: Text(
                  widget.email,
                  style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge!.color),
                ),
              ),
              SizedBox(height: 20.sp),
              CustomFadeInLeft(
                child: CustomTextFormField(
                  decoration: InputDecoration(
                    hintText: "Code".hardcoded,
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                    ),
                  ),
                  controller: _codeController,
                  validator: (value) =>
                      Validation.validateMandatoryField(value, context),
                ),
              ),
              SizedBox(height: 30.sp),
              CustomFadeInUp(
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(double.maxFinite, 42)),
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
      context.read<AuthBloc>().add(
          CheckCodeEv(email: widget.email, code: _codeController.text.trim()));
    }
  }
}
