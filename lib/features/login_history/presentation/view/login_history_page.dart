import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/design/widgets/app_appbar.dart';
import '../../../../core/design/widgets/app_status_badge.dart';
import '../../../../core/utils/wrappers/escape_pop_wrapper_v2.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/component/pagination_component.dart';
import '../../domain/entities/login_history_entity.dart';
import '../../domain/repositories/login_history_repository.dart';
import '../view_model/login_history_cubit.dart';
import '../view_model/login_history_state.dart';

class LoginHistoryPage extends StatelessWidget {
  final bool showAppBar;
  final Widget? leading;

  const LoginHistoryPage({
    super.key,
    this.showAppBar = true,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    LoginHistoryRepository? repository;
    try {
      repository = sl<LoginHistoryRepository>();
    } catch (_) {}

    if (repository == null) {
      return const Scaffold(
        body: Center(
          child: Text('LoginHistoryRepository is not registered in service locator.'),
        ),
      );
    }

    return BlocProvider(
      create: (context) => LoginHistoryCubit(
        repository: repository!,
      )..loadInitialData(),
      child: _LoginHistoryView(
        showAppBar: showAppBar,
        leading: leading,
      ),
    );
  }
}

class _LoginHistoryView extends StatefulWidget {
  final bool showAppBar;
  final Widget? leading;

  const _LoginHistoryView({
    required this.showAppBar,
    this.leading,
  });

  @override
  State<_LoginHistoryView> createState() => _LoginHistoryViewState();
}

class _LoginHistoryViewState extends State<_LoginHistoryView> {
  final FocusNode keyboardFocusNode = FocusNode();

  @override
  void dispose() {
    keyboardFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = l10n?.appTitle ?? 'Login History';

    final body = SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildTableBody(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return EscapePoppableWrapperV2(
      onPop: () async {
        final navigator = Navigator.of(context);
        if (navigator.canPop()) {
          navigator.pop();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppCustomAppbar(
                title: title,
                leading: widget.leading,
              )
            : null,
        backgroundColor: const Color(0xFFF8FAFC),
        body: body,
      ),
    );
  }

  Widget _buildTableBody(BuildContext context) {
    return BlocBuilder<LoginHistoryCubit, LoginHistoryState>(
      builder: (context, state) {
        final cubit = context.read<LoginHistoryCubit>();
        final lastResponse = cubit.lastResponse;

        if (state is LoginHistoryLoading && lastResponse == null) {
          return const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        if (lastResponse != null || state is LoginHistoryLoaded) {
          final paginatedResponse =
              (state is LoginHistoryLoaded) ? state.response : lastResponse!;

          return PaginatedListWrapper<LoginHistoryEntity>(
            searchFocusNode: keyboardFocusNode,
            enableSearch: false,
            data: PaginatedData<LoginHistoryEntity>(
              items: paginatedResponse.content,
              totalItems: paginatedResponse.totalElements,
              currentPage: paginatedResponse.number,
              totalPages: paginatedResponse.totalPages,
              itemsPerPage: paginatedResponse.size,
            ),
            currentSearchQuery: cubit.searchQuery,
            onPageChange: (page) => cubit.loadLoginHistory(page: page),
            onItemsPerPageChange: (size) => cubit.loadLoginHistory(size: size),
            onSearchQueryChange: (query) => cubit.onSearchQueryChange(query),
            bodyBuilder: (context, data) {
              if (data.items.isEmpty) {
                return const Center(child: Text('No login history found.'));
              }
              final startIndex = (data.currentPage - 1) * data.itemsPerPage;
              return _LoginHistoryTable(
                data.items,
                startIndex: startIndex,
              );
            },
          );
        }

        if (state is LoginHistoryError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _LoginHistoryTable extends StatelessWidget {
  final List<LoginHistoryEntity> items;
  final int startIndex;

  const _LoginHistoryTable(
    this.items, {
    this.startIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth > 650 ? constraints.maxWidth : 650,
            ),
            child: SizedBox(
              width: constraints.maxWidth > 650 ? constraints.maxWidth : 650,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: const Row(
                      children: [
                        Expanded(flex: 1, child: Text('Sl No.', style: _headerStyle)),
                        Expanded(flex: 4, child: Text('Username', style: _headerStyle)),
                        Expanded(flex: 4, child: Text('Date & Time', style: _headerStyle)),
                        Expanded(flex: 2, child: Text('Status', style: _headerStyle)),
                      ],
                    ),
                  ),
                  // Table Body
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const Divider(height: 1, color: Color(0xFFE2E8F0)),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  '${startIndex + index + 1}',
                                  style: const TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  item.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF0F172A),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  _formatDate(item.loginTime),
                                  style: const TextStyle(
                                    color: Color(0xFF475569),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AppStatusBadge(status: item.status),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('yyyy-MM-dd hh:mm a').format(date);
    } catch (e) {
      return isoString;
    }
  }
}

const _headerStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Color(0xFF64748B),
);
