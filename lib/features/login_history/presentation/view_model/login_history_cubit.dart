import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/models/paginated_response.dart';
import '../../domain/entities/login_history_entity.dart';
import '../../domain/repositories/login_history_repository.dart';
import 'login_history_state.dart';

class LoginHistoryCubit extends Cubit<LoginHistoryState> {
  final LoginHistoryRepository repository;

  LoginHistoryCubit({
    required this.repository,
  }) : super(LoginHistoryInitial());

  Timer? _debouncer;
  int _page = 1;
  int _pageSize = 10;
  PaginatedResponse<LoginHistoryEntity>? lastResponse;
  String searchQuery = '';

  Future<void> loadInitialData() async {
    await loadLoginHistory();
  }

  Future<void> loadLoginHistory({
    String? search,
    int? page,
    int? size,
  }) async {
    if (search != null) searchQuery = search;
    if (page != null) _page = page;
    if (size != null) {
      _pageSize = size;
      _page = 1;
    }

    emit(LoginHistoryLoading());

    final result = await repository.getLoginHistory(
      username: searchQuery.isNotEmpty ? searchQuery : null,
      page: _page,
      size: _pageSize,
    );

    result.fold(
      (failure) => emit(LoginHistoryError(failure.message)),
      (response) {
        lastResponse = response;
        emit(LoginHistoryLoaded(response));
      },
    );
  }

  void onSearchQueryChange(String query) {
    searchQuery = query;
    _debouncer?.cancel();
    _debouncer = Timer(
      const Duration(milliseconds: 500),
      () => loadLoginHistory(page: 1),
    );
  }

  @override
  Future<void> close() {
    _debouncer?.cancel();
    return super.close();
  }
}
