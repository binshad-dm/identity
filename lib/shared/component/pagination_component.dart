import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import '../../core/design/widgets/app_button.dart';
import '../../core/design/widgets/app_text_form_field.dart';
import '../../core/design/responsive/responsive_builder.dart';

class PaginatedData<T> extends Equatable {
  final List<T> items;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;

  const PaginatedData({
    required this.items,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
  });

  @override
  List<Object?> get props => [
        items,
        totalItems,
        currentPage,
        totalPages,
        itemsPerPage,
      ];

  PaginatedData<T> copyWith({
    List<T>? items,
    int? totalItems,
    int? currentPage,
    int? totalPages,
    int? itemsPerPage,
  }) {
    return PaginatedData<T>(
      items: items ?? this.items,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class PaginatedListWrapper<T> extends StatelessWidget {
  final PaginatedData<T> data;
  final String currentSearchQuery;
  final ValueChanged<int> onPageChange;
  final ValueChanged<int> onItemsPerPageChange;
  final ValueChanged<String> onSearchQueryChange;
  final List<int> itemsPerPageOptions;
  final bool enableSearch;
  final EdgeInsetsGeometry padding;
  final String searchHint;
  final String emptyStateMessage;
  final Widget? header;
  final FocusNode? searchFocusNode;
  final double? searchWidth;

  /// Here you inject your custom body instead of being forced into ListView.
  final Widget Function(BuildContext context, PaginatedData<T> data)
      bodyBuilder;

  const PaginatedListWrapper({
    super.key,
    required this.data,
    required this.currentSearchQuery,
    required this.onPageChange,
    required this.onItemsPerPageChange,
    required this.onSearchQueryChange,
    required this.bodyBuilder,
    this.itemsPerPageOptions = const [5, 10, 20, 50],
    this.enableSearch = true,
    this.padding = const EdgeInsets.all(16),
    this.header,
    this.searchHint = 'Search...',
    this.emptyStateMessage = 'No items found',
    this.searchFocusNode,
    this.searchWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          if (header != null && data.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: header!,
            ),
          Expanded(
            child: data.items.isEmpty
                ? _buildEmptyState(context)
                : bodyBuilder(context, data),
          ),
          if (data.totalPages > 1)
            _PaginationControls(
              currentPage: data.currentPage,
              totalPages: data.totalPages,
              onPageChange: onPageChange,
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (enableSearch)
          searchWidth != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: searchWidth,
                    child: _SearchField(
                      currentSearchQuery: currentSearchQuery,
                      onSearchQueryChange: onSearchQueryChange,
                      searchHint: searchHint,
                      focusNode: searchFocusNode,
                    ),
                  ),
                )
              : _SearchField(
                  currentSearchQuery: currentSearchQuery,
                  onSearchQueryChange: onSearchQueryChange,
                  searchHint: searchHint,
                  focusNode: searchFocusNode,
                ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TotalItemCount(
              totalItems: data.totalItems,
              itemsPerPage: data.itemsPerPage,
              currentPage: data.currentPage,
            ),
            _ItemsPerPageSelector(
              itemsPerPage: data.itemsPerPage,
              itemsPerPageOptions: itemsPerPageOptions,
              onItemsPerPageChange: onItemsPerPageChange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Theme.of(context).disabledColor,
          ),
          const SizedBox(height: 12),
          Text(
            emptyStateMessage,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).disabledColor,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// === MAIN WIDGET ===
class PaginatedListView<T> extends StatelessWidget {
  final PaginatedData<T> data;
  final String currentSearchQuery;
  final ValueChanged<int> onPageChange;
  final ValueChanged<int> onItemsPerPageChange;
  final ValueChanged<String> onSearchQueryChange;
  final Widget Function(BuildContext, T, int index) itemBuilder;
  final List<int> itemsPerPageOptions;
  final bool enableSearch;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;
  final String searchHint;
  final String emptyStateMessage;
  final Widget? header;
  final Widget? listFirstWidget;
  final Widget? listLastWidget;
  final FocusNode? searchFocusNode;
  final double? searchWidth;

  const PaginatedListView({
    super.key,
    required this.data,
    required this.currentSearchQuery,
    required this.onPageChange,
    required this.onItemsPerPageChange,
    required this.onSearchQueryChange,
    required this.itemBuilder,
    this.itemsPerPageOptions = const [5, 10, 20, 50],
    this.enableSearch = true,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.header,
    this.listFirstWidget,
    this.listLastWidget,
    this.searchHint = 'Search...',
    this.emptyStateMessage = 'No items found',
    this.searchFocusNode,
    this.searchWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          if (header != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: header!,
            ),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (enableSearch)
          searchWidth != null
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: searchWidth,
                    child: _SearchField(
                      currentSearchQuery: currentSearchQuery,
                      onSearchQueryChange: onSearchQueryChange,
                      searchHint: searchHint,
                      focusNode: searchFocusNode,
                    ),
                  ),
                )
              : _SearchField(
                  currentSearchQuery: currentSearchQuery,
                  onSearchQueryChange: onSearchQueryChange,
                  searchHint: searchHint,
                  focusNode: searchFocusNode,
                ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TotalItemCount(
              totalItems: data.totalItems,
              itemsPerPage: data.itemsPerPage,
              currentPage: data.currentPage,
            ),
            _ItemsPerPageSelector(
              itemsPerPage: data.itemsPerPage,
              itemsPerPageOptions: itemsPerPageOptions,
              onItemsPerPageChange: onItemsPerPageChange,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (data.items.isEmpty &&
        listFirstWidget == null &&
        listLastWidget == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: Theme.of(context).disabledColor,
            ),
            const SizedBox(height: 12),
            Text(
              emptyStateMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            clipBehavior: Clip.antiAlias,
            physics: physics,
            itemCount: data.items.length +
                (listFirstWidget != null ? 1 : 0) +
                (listLastWidget != null ? 1 : 0),
            itemBuilder: (context, index) {
              // FIRST widget (index 0)
              if (listFirstWidget != null) {
                if (index == 0) return listFirstWidget!;
              }

              // Compute where LAST widget should appear
              final lastIndex =
                  data.items.length + (listFirstWidget != null ? 1 : 0);
              if (listLastWidget != null && index == lastIndex) {
                return listLastWidget!;
              }

              // NORMAL items
              final offset = listFirstWidget != null ? 1 : 0;
              final itemIndex = index - offset;
              if (itemIndex < 0 || itemIndex >= data.items.length) {
                return const SizedBox.shrink();
              }

              return itemBuilder(context, data.items[itemIndex], itemIndex);
            },
          ),
        ),
        if (data.totalPages > 1)
          _PaginationControls(
            currentPage: data.currentPage,
            totalPages: data.totalPages,
            onPageChange: onPageChange,
          ),
      ],
    );
  }
}

// === PRIVATE SUB-WIDGETS ===

class _SearchField extends StatefulWidget {
  final String currentSearchQuery;
  final ValueChanged<String> onSearchQueryChange;
  final String searchHint;
  final FocusNode? focusNode;

  const _SearchField({
    required this.currentSearchQuery,
    required this.onSearchQueryChange,
    required this.searchHint,
    this.focusNode,
  });

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentSearchQuery);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.focusNode?.requestFocus();
    });
  }

  // @override
  // void didUpdateWidget(covariant _SearchField oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.currentSearchQuery != widget.currentSearchQuery) {
  //     _controller.text = widget.currentSearchQuery;
  //   }
  // }

  @override
  void didUpdateWidget(covariant _SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only sync the controller when the field is not focused (i.e. the query
    // was changed externally — e.g. programmatic clear — not by the user typing).
    // This prevents mid-input text (including spaces) from being clobbered by
    // a rebuild triggered by an intermediate loading state.
    final hasFocus = widget.focusNode?.hasFocus ?? false;
    if (!hasFocus &&
        oldWidget.currentSearchQuery != widget.currentSearchQuery &&
        _controller.text != widget.currentSearchQuery) {
      _controller.value = TextEditingValue(
        text: widget.currentSearchQuery,
        selection: TextSelection.collapsed(
          offset: widget.currentSearchQuery.length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: _controller,
      focusNode: widget.focusNode,
      onChanged: widget.onSearchQueryChange,
      hintText: widget.searchHint,
      prefix: const Icon(Icons.search),
      suffix: _controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: () {
                _controller.clear();
                widget.onSearchQueryChange('');
                widget.focusNode?.requestFocus();
                _controller.selection =
                    const TextSelection.collapsed(offset: 0);
              },
            )
          : null,
      textInputAction: TextInputAction.search,
    );
  }
}

class _TotalItemCount extends StatelessWidget {
  final int totalItems;
  final int itemsPerPage;
  final int currentPage;

  const _TotalItemCount({
    required this.totalItems,
    required this.itemsPerPage,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the range of items being shown
    final int startItem =
        totalItems == 0 ? 0 : ((currentPage - 1) * itemsPerPage) + 1;
    final int endItem =
        totalItems == 0 ? 0 : math.min(currentPage * itemsPerPage, totalItems);

    return Text(
      'Showing $startItem-$endItem of $totalItems records',
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _ItemsPerPageSelector extends StatelessWidget {
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final ValueChanged<int> onItemsPerPageChange;

  const _ItemsPerPageSelector({
    required this.itemsPerPage,
    required this.itemsPerPageOptions,
    required this.onItemsPerPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Show:',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(width: 4),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: itemsPerPage,
            items: itemsPerPageOptions.map((value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            }).toList(),
            onChanged: (value) => onItemsPerPageChange(value ?? itemsPerPage),
            isDense: true,
          ),
        ),
      ],
    );
  }
}

class _PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChange;

  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox();

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final isSmall = screenSize == ScreenSize.small;

        if (isSmall) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 12,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavigationButton(
                      context,
                      icon: Icons.first_page,
                      isEnabled: currentPage > 1,
                      onPressed: () => onPageChange(1),
                      tooltip: 'First page',
                    ),
                    _buildNavigationButton(
                      context,
                      icon: Icons.chevron_left,
                      isEnabled: currentPage > 1,
                      onPressed: () => onPageChange(currentPage - 1),
                      tooltip: 'Previous page',
                    ),
                    const SizedBox(width: 4),
                    _buildPaginationIndicator(context, isSmall: true),
                    const SizedBox(width: 4),
                    _buildNavigationButton(
                      context,
                      icon: Icons.chevron_right,
                      isEnabled: currentPage < totalPages,
                      onPressed: () => onPageChange(currentPage + 1),
                      tooltip: 'Next page',
                    ),
                    _buildNavigationButton(
                      context,
                      icon: Icons.last_page,
                      isEnabled: currentPage < totalPages,
                      onPressed: () => onPageChange(totalPages),
                      tooltip: 'Last page',
                    ),
                  ],
                ),
                _pageSearcher(context, isSmall: true),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavigationButton(
                context,
                icon: Icons.first_page,
                isEnabled: currentPage > 1,
                onPressed: () => onPageChange(1),
                tooltip: 'First page',
              ),
              _buildNavigationButton(
                context,
                icon: Icons.chevron_left,
                isEnabled: currentPage > 1,
                onPressed: () => onPageChange(currentPage - 1),
                tooltip: 'Previous page',
              ),
              const SizedBox(width: 8),
              _buildPaginationIndicator(context),
              const SizedBox(width: 8),
              _buildNavigationButton(
                context,
                icon: Icons.chevron_right,
                isEnabled: currentPage < totalPages,
                onPressed: () => onPageChange(currentPage + 1),
                tooltip: 'Next page',
              ),
              _buildNavigationButton(
                context,
                icon: Icons.last_page,
                isEnabled: currentPage < totalPages,
                onPressed: () => onPageChange(totalPages),
                tooltip: 'Last page',
              ),
              const SizedBox(width: 16),
              _pageSearcher(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required bool isEnabled,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: isEnabled ? onPressed : null,
      tooltip: tooltip,
      iconSize: 20,
    );
  }

  Widget _buildPaginationIndicator(BuildContext context,
      {bool isSmall = false}) {
    final maxVisiblePages = isSmall ? 2 : 5;

    // If we have fewer pages than our max, show them all
    if (totalPages <= maxVisiblePages) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          totalPages,
          (i) => _buildPageButton(context, i + 1, isSmall: isSmall),
        ),
      );
    }

    // Handle truncation for many pages
    final List<Widget> indicators = [];

    if (currentPage <= (isSmall ? 1 : 3)) {
      // Near the start
      final endPage = (currentPage + (isSmall ? 0 : 1)).clamp(1, totalPages);
      indicators.addAll(_buildPageRange(context, 1, endPage, isSmall: isSmall));
      if (endPage < totalPages) {
        indicators.add(const _PageSeparator());
        indicators.add(_buildPageButton(context, totalPages, isSmall: isSmall));
      }
    } else if (currentPage >= totalPages - (isSmall ? 0 : 2)) {
      // Near the end
      final startPage = (currentPage - (isSmall ? 0 : 1)).clamp(1, totalPages);
      if (startPage > 1) {
        indicators.add(_buildPageButton(context, 1, isSmall: isSmall));
        indicators.add(const _PageSeparator());
      }
      indicators.addAll(
          _buildPageRange(context, startPage, totalPages, isSmall: isSmall));
    } else {
      // Middle
      indicators.add(_buildPageButton(context, 1, isSmall: isSmall));
      indicators.add(const _PageSeparator());
      indicators.addAll(_buildPageRange(context,
          currentPage - (isSmall ? 0 : 1), currentPage + (isSmall ? 0 : 1),
          isSmall: isSmall));
      indicators.add(const _PageSeparator());
      indicators.add(_buildPageButton(context, totalPages, isSmall: isSmall));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: indicators,
    );
  }

  List<Widget> _buildPageRange(BuildContext context, int start, int end,
      {bool isSmall = false}) {
    return List.generate(
      end - start + 1,
      (i) => _buildPageButton(context, start + i, isSmall: isSmall),
    );
  }

  Widget _buildPageButton(BuildContext context, int page,
      {bool isSmall = false}) {
    final isCurrent = page == currentPage;

    return InkWell(
      onTap: isCurrent ? null : () => onPageChange(page),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        constraints: BoxConstraints(
          minWidth: isSmall ? 28 : 32,
          minHeight: isSmall ? 28 : 32,
        ),
        height: isSmall ? 28 : 32,
        padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isCurrent ? Theme.of(context).colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isCurrent
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Text(
          '$page',
          style: TextStyle(
            fontSize: isSmall ? 12 : 14,
            color: isCurrent
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
          semanticsLabel: isCurrent ? 'Current page $page' : 'Go to page $page',
        ),
      ),
    );
  }

  Widget _pageSearcher(BuildContext context, {bool isSmall = false}) {
    TextEditingController _controller = TextEditingController();
    return Container(
      height: isSmall ? 28 : 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Page",
              style: TextStyle(fontSize: isSmall ? 12 : 14),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: isSmall ? 28 : 32,
            width: isSmall ? 54 : 64,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmall ? 12 : 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                ),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$')),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppButton(
            text: "Go",
            onPressed: () {
              final pageText = _controller.text;
              if (pageText.isNotEmpty) {
                final page = int.parse(pageText);
                if (page > 0 && page <= totalPages) {
                  onPageChange(page);
                } else {
                  onPageChange(totalPages);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _PageSeparator extends StatelessWidget {
  const _PageSeparator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('...'),
    );
  }
}
