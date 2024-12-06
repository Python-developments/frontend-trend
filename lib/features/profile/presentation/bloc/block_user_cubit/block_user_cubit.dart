// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_trend/core/utils/entities/paged_list.dart';
import 'package:frontend_trend/features/profile/data/models/profile_model.dart';
import 'package:frontend_trend/features/profile/data/repository/profile_repository.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../../core/utils/entities/pagination_param.dart';
import '../../../../posts/presentation/bloc/posts_bloc/posts_bloc.dart';
import '../../../../vlogs/presentation/bloc/vlogs_bloc/vlogs_bloc.dart';

part 'block_user_state.dart';

class BlockUserCubit extends Cubit<BlockUserState> {
  final ProfileRepository profileRepository;
  BlockUserCubit({
    required this.profileRepository,
  }) : super(BlockUserInitialState());

  performBlockUser(int blockedUserId, BuildContext context) async {
    emit(BlockUserLoadingState());
    final result = await profileRepository.blockUser(blockedUserId);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        context.read<PostsBloc>().add(GetAllPostsEvent(
            params: PaginationParam(page: 1), emitLoading: false));
        context.read<VlogsBloc>().add(GetAllVlogsEvent(
            params: PaginationParam(page: 1), emitLoading: false));

        emit(BlockUserSuccessState());
      },
    );
  }

  performUnBlockUser(int blockedUserId, BuildContext context) async {
    emit(BlockUserLoadingState());
    final result = await profileRepository.unblockUser(blockedUserId);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) {
        getAllBlockList(context, false);
        context.read<PostsBloc>().add(GetAllPostsEvent(
            params: PaginationParam(page: 1), emitLoading: false));
      },
    );
  }

  getAllBlockList(BuildContext context, [bool showLoading = true]) async {
    if (showLoading) {
      emit(BlockListLoadingState());
    }

    final result = await profileRepository.getBlockList();
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (users) {
        emit(BlockListLoadedState(users));
      },
    );
  }

  BlockUserState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return BlockUserErrorState(
        message: (failure).message,
      );
    } else if (failure is NoInternetConnectionFailure) {
      return BlockUserNoInternetConnectionState();
    } else {
      return const BlockUserErrorState(
        message: AppStrings.someThingWentWrong,
      );
    }
  }
}
