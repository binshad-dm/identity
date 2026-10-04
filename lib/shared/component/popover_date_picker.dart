import 'package:flutter/material.dart';

class AppPopoverDatePicker extends StatefulWidget {
  final String label;
  final String currentValue;
  final ValueChanged<String> onDateSelected;
  final double width;
  final DateTime? minDate;
  final DateTime? maxDate;

  const AppPopoverDatePicker({
    super.key,
    required this.label,
    required this.currentValue,
    required this.onDateSelected,
    this.width = 200,
    this.minDate,
    this.maxDate,
  });

  @override
  State<AppPopoverDatePicker> createState() => _AppPopoverDatePickerState();
}

class _AppPopoverDatePickerState extends State<AppPopoverDatePicker> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpened = false;

  void _toggleDropdown() {
    if (_isOpened) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry != null) return;
    
    // Ensure that the render object is ready before showing overlay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
        setState(() {
          _isOpened = true;
        });
      }
    });
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
    if (mounted) {
      setState(() {
        _isOpened = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    final parentContext = context;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Invisible barrier to close on tap outside
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: 350,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 5),
              child: InheritedTheme.captureAll(
                parentContext,
                MediaQuery(
                  data: MediaQuery.of(parentContext),
                  child: Directionality(
                    textDirection: Directionality.of(parentContext),
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TooltipVisibility(
                              visible: false,
                              child: CalendarDatePicker(
                                initialDate: _getInitialDate(),
                                firstDate: widget.minDate ?? DateTime(2000),
                                lastDate: widget.maxDate ?? DateTime(2100),
                                onDateChanged: (date) {
                                  widget.onDateSelected(_formatDate(date));
                                  _closeDropdown();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getInitialDate() {
    DateTime date = _parseDate(widget.currentValue);
    if (widget.minDate != null && date.isBefore(widget.minDate!)) {
      date = widget.minDate!;
    }
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
      date = widget.maxDate!;
    }
    return date;
  }

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
      return DateTime.tryParse(dateStr) ?? DateTime.now();
    } catch (_) {
      return DateTime.now();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showLabel = widget.label.isNotEmpty;
          final availableWidth = constraints.maxWidth;
          
          // If space is very tight, hide label or stack vertically (but here we just makes it flexible)
          return Row(
            children: [
              if (showLabel)
                SizedBox(
                  width: availableWidth > 400 ? 150 : 100, // Responsive label width
                  child: Text(
                    widget.label,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              Expanded(
                child: InkWell(
                  onTap: _toggleDropdown,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: widget.width),
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: _isOpened ? const Color(0xFF139D90) : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.currentValue,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: _isOpened ? const Color(0xFF139D90) : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
