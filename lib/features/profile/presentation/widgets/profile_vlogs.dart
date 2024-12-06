// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_trend/core/utils/toast_utils.dart';
import 'package:frontend_trend/core/widgets/logo_loader.dart';
import 'package:frontend_trend/core/widgets/my_error_widget.dart';
import 'package:frontend_trend/core/widgets/no_internet_connection_widget.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/entities/pagination_param.dart';
import '../../../../core/widgets/post_square_media.dart';
import '../../../vlogs/presentation/bloc/vlogs_bloc/vlogs_bloc.dart';

class ProfileVlogsWidget extends StatefulWidget {
  final ProfileModel profile;
  final bool isVlog;
  final ScrollController scrollController;
  const ProfileVlogsWidget({
    Key? key,
    required this.profile,
    required this.isVlog,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<ProfileVlogsWidget> createState() => _ProfileVlogsWidgetState();
}

class _ProfileVlogsWidgetState extends State<ProfileVlogsWidget> {
  late PaginationParam _paginationParams;
  int page = 1;

  void _getAllVlogs() {
    context.read<VlogsBloc>().add(GetProfileVlogsEvent(
        profileId: widget.profile.id, params: (_paginationParams..page = 1)));
  }

  void _fetchVlogsNextPage() {
    final bloc = context.read<VlogsBloc>();
    if (bloc.state.canLoadMore && !bloc.isLoading) {
      bloc.add(GetProfileVlogsEvent(
        emitLoading: false,
        profileId: widget.profile.id,
        params: _paginationParams..page = _paginationParams.page + 1,
      ));
      page = _paginationParams.page + 1;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _paginationParams = PaginationParam(page: 1);
    _getAllVlogs();

    widget.scrollController.addListener(() {
      if (mounted) {
        if (widget.scrollController.offset >=
                widget.scrollController.position.maxScrollExtent &&
            !widget.scrollController.position.outOfRange) {
          if (widget.isVlog) {
            _fetchVlogsNextPage();
          }
        }
      }
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (widget.scrollController.hasClients &&
          widget.scrollController.position.maxScrollExtent <= 0) {
        if (widget.isVlog) {
          _fetchVlogsNextPage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VlogsBloc, VlogsState>(
      listener: (context, state) {
        if (state is VlogsNoInternetConnectionState) {
          ToastUtils(context).showNoInternetConnectionToast();
        } else if (state is VlogsErrorState) {
          ToastUtils(context).showCustomToast(message: state.message);
        }
      },
      builder: (context, state) {
        if (state is VlogsLoadedState) {
          if (state.vlogs.isEmpty) return const SizedBox();

          bool isLoadingMore = (page != 1 &&
              state.canLoadMore &&
              (context.read<VlogsBloc>().isLoading));
          return Column(
            children: [
              GridView.builder(
                itemCount: state.vlogs.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: .6),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    context.push(
                      Routes.vlogDetails(state.vlogs[index].id),
                      extra: context.read<VlogsBloc>(),
                    );
                  },
                  child: CustomSquarePostMediaWidget(
                      imageUrl: state.vlogs[index].videoThumb),
                ),
              ),
              if (isLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.sp),
                  child: LogoLoader(
                    size: 15.sp,
                  ),
                ),
            ],
          );
        } else if (state is VlogsErrorState) {
          return Padding(
            padding: EdgeInsets.only(top: 20.sp),
            child: MyErrorWidget(message: state.message, onRetry: _getAllVlogs),
          );
        } else if (state is VlogsNoInternetConnectionState) {
          return Padding(
            padding: EdgeInsets.only(top: 20.sp),
            child: NoInternetConnectionWidget(onRetry: _getAllVlogs),
          );
        }
        return Padding(
          padding: EdgeInsets.only(top: 20.sp),
          child: Center(
              child: LogoLoader(
            size: 30.sp,
          )),
        );
      },
    );
  }
}
