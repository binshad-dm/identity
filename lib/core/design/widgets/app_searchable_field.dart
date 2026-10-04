import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppSearchableField<T> extends StatefulWidget {
  final String? label;
  final String? hintText;
  final FutureOr<List<T>> Function(String query)? suggestionsCallback;
  final Future<List<T>> Function(String query, int page)?
  paginatedSuggestionsCallback;
  final int pageSize;
  final int initialPage;
  final Widget Function(BuildContext context, T suggestion) itemBuilder;
  final void Function(T suggestion) onSuggestionSelected;
  final String Function(T suggestion) itemToString;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool required;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? isDense;
  final String? initialValue;

  const AppSearchableField({
    super.key,
    this.label,
    this.hintText,
    this.suggestionsCallback,
    this.paginatedSuggestionsCallback,
    this.pageSize = 10,
    this.initialPage = 1,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    required this.itemToString,
    this.controller,
    this.focusNode,
    this.required = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.isDense = false,
    this.initialValue,
  }) : assert(
         suggestionsCallback != null || paginatedSuggestionsCallback != null,
         'Either suggestionsCallback or paginatedSuggestionsCallback must be provided',
       );

  @override
  State<AppSearchableField<T>> createState() => _AppSearchableFieldState<T>();
}

class _AppSearchableFieldState<T> extends State<AppSearchableField<T>> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final MenuController _menuController = MenuController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String _currentQuery = '';
  String? _selectedText;
  List<T> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = widget.initialValue!;
      _selectedText = widget.initialValue!;
    }
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(AppSearchableField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool changed = false;
    if (widget.controller != oldWidget.controller &&
        widget.controller != null) {
      _controller = widget.controller!;
      changed = true;
    }
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != null) {
      _controller.text = widget.initialValue!;
      _selectedText = widget.initialValue!;
      changed = true;
    }
    if (widget.focusNode != oldWidget.focusNode && widget.focusNode != null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode = widget.focusNode!;
      _focusNode.addListener(_onFocusChange);
      changed = true;
    }
    if (changed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.removeListener(_onFocusChange);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (!_menuController.isOpen) {
        _menuController.open();
      }
      final query = (_selectedText != null && _controller.text == _selectedText)
          ? ''
          : _controller.text;
      _onSearch(query);
      if (_selectedText != null && _controller.text == _selectedText) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    } else {
      if (_menuController.isOpen) {
        _menuController.close();
      }
      if (_selectedText != null &&
          _controller.text.isNotEmpty &&
          _controller.text != _selectedText) {
        _controller.text = _selectedText!;
      }
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (widget.paginatedSuggestionsCallback == null) return;
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 40) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;
    if (widget.paginatedSuggestionsCallback == null) return;

    setState(() => _isLoadingMore = true);

    final nextPage = _currentPage + 1;
    try {
      final newResults = await widget.paginatedSuggestionsCallback!(
        _currentQuery,
        nextPage,
      );
      if (mounted) {
        setState(() {
          _suggestions.addAll(newResults);
          _currentPage = nextPage;
          _isLoadingMore = false;
          if (newResults.isEmpty || newResults.length < widget.pageSize) {
            _hasMore = false;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  void _onSearch(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _isLoadingMore = false;
        _currentPage = widget.initialPage;
        _currentQuery = query;
      });

      if (!_menuController.isOpen && _focusNode.hasFocus) {
        _menuController.open();
      }

      try {
        if (widget.paginatedSuggestionsCallback != null) {
          final results = await widget.paginatedSuggestionsCallback!(
            query,
            widget.initialPage,
          );
          if (mounted) {
            setState(() {
              _suggestions = results;
              _isLoading = false;
              _hasMore = results.length >= widget.pageSize;
            });
          }
        } else if (widget.suggestionsCallback != null) {
          final results = await widget.suggestionsCallback!(query);
          if (mounted) {
            setState(() {
              _suggestions = results;
              _isLoading = false;
              _hasMore = false;
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _suggestions = [];
            _hasMore = false;
          });
        }
      }
    });
  }

  void _handleSuggestionSelected(T suggestion) {
    final text = widget.itemToString(suggestion);
    _selectedText = text;
    _controller.text = text;
    widget.onSuggestionSelected(suggestion);
    widget.onChanged?.call(text);
    if (_menuController.isOpen) {
      _menuController.close();
    }
    _focusNode.unfocus();
  }

  Widget _buildDefaultSuffixIcon() {
    if (_isLoading && _suggestions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_controller.text.isNotEmpty && !widget.readOnly)
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _controller.clear();
              _selectedText = null;
              widget.onChanged?.call('');
              _onSearch('');
            },
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.clear, size: 16, color: Color(0xFF94A3B8)),
            ),
          ),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (_menuController.isOpen) {
              _menuController.close();
            } else {
              _focusNode.requestFocus();
              _menuController.open();
              final query =
                  (_selectedText != null && _controller.text == _selectedText)
                  ? ''
                  : _controller.text;
              _onSearch(query);
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: Color(0xFF94A3B8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Row(
            children: [
              Text(widget.label!, style: const TextStyle(fontSize: 12)),
              if (widget.required)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const Gap(4),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            return MenuAnchor(
              controller: _menuController,
              crossAxisUnconstrained: false,
              style: MenuStyle(
                elevation: MaterialStateProperty.all(8),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all(
                  Size(constraints.maxWidth, 0),
                ),
                maximumSize: MaterialStateProperty.all(
                  Size(constraints.maxWidth, 300),
                ),
              ),
              menuChildren: _buildMenuChildren(constraints.maxWidth),
              builder: (context, controller, child) {
                return TextFormField(
                  controller: _controller,
                  focusNode: _focusNode,
                  readOnly: widget.readOnly,
                  onTap: () {
                    if (!_menuController.isOpen) {
                      _menuController.open();
                    }
                    final query =
                        (_selectedText != null &&
                            _controller.text == _selectedText)
                        ? ''
                        : _controller.text;
                    _onSearch(query);
                    if (_selectedText != null &&
                        _controller.text == _selectedText) {
                      _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length,
                      );
                    }
                  },
                  onChanged: (val) {
                    _selectedText = null;
                    _onSearch(val);
                    widget.onChanged?.call(val);
                  },
                  onFieldSubmitted: widget.onFieldSubmitted,
                  validator: widget.validator,
                  style: const TextStyle(fontSize: 13, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.normal,
                    ),
                    filled: true,
                    fillColor: widget.readOnly
                        ? const Color(0xFFF1F5F9)
                        : const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 9,
                    ),
                    isDense: widget.isDense,
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 24,
                    ),
                    suffixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 24,
                    ),
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon ?? _buildDefaultSuffixIcon(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF0F4C81),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  List<Widget> _buildMenuChildren(double width) {
    if (_isLoading && _suggestions.isEmpty) {
      return [
        Container(
          width: width,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              Gap(10),
              Text(
                'Searching...',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ];
    }

    if (_suggestions.isEmpty && !_isLoading) {
      return [
        Container(
          width: width,
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: const Text(
            'No results found',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ];
    }

    final hasPagination = widget.paginatedSuggestionsCallback != null;
    final showLoadingMore = hasPagination && _isLoadingMore;

    return [
      SizedBox(
        width: width,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length + (showLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _suggestions.length) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        Gap(8),
                        Text(
                          'Loading more...',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final suggestion = _suggestions[index];
                return InkWell(
                  onTap: () => _handleSuggestionSelected(suggestion),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    alignment: Alignment.centerLeft,
                    child: widget.itemBuilder(context, suggestion),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ];
  }
}
