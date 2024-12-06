import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:frontend_trend/features/notifications/data/models/not_model.dart';
import '../../../data/repository/nots_repository.dart';
import '../../../../../core/error/failures.dart';
import '../../../../../core/resources/strings_manager.dart';
part 'not_event.dart';
part 'not_state.dart';

class NotBloc extends Bloc<NotEvent, NotState> {
  final NotificationsRepository postsRepository;
  NotBloc({required this.postsRepository}) : super(const NotsInitialState()) {
    on<GetAllNotsEvent>(
      _onGetAllNotificationsEvent,
      transformer: _debounceAndSwitch(Duration.zero),
    );
  }
  bool isLoading = false;
  EventTransformer<PostsEvent> _debounceAndSwitch<PostsEvent>(
      Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  FutureOr<void> _onGetAllNotificationsEvent(
      GetAllNotsEvent event, Emitter<NotState> emit) async {
    isLoading = true;
    if (event.emitLoading) {
      emit(NotsLoadingState(
        nots: state.nots,
      ));
    }
    final failureOrPosts = await postsRepository.getAllNotifications();
    emit(failureOrPosts.fold(
      (failure) => _mapFailureToState(failure),
      (postsPagedList) => NotsLoadedState(
        nots: postsPagedList.items,
      ),
    ));
    isLoading = false;
  }

  NotState _mapFailureToState(Failure failure) {
    if (failure is MessageFailure) {
      return NotsErrorState(
        message: (failure).message,
        nots: state.nots,
      );
    } else if (failure is NoInternetConnectionFailure) {
      return NotsNoInternetConnectionState(
        nots: state.nots,
      );
    } else {
      return NotsErrorState(
        nots: state.nots,
        message: AppStrings.someThingWentWrong,
      );
    }
  }
}
