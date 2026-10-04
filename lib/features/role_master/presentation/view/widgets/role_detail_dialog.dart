import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_status_badge.dart';
import 'package:identity/features/role_master/domain/entities/role_entity.dart';
import '../../view_model/role_cubit.dart';
import '../../view_model/role_state.dart';

class RoleDetailDialog extends StatefulWidget {
  final String roleId;

  const RoleDetailDialog({super.key, required this.roleId});

  @override
  State<RoleDetailDialog> createState() => _RoleDetailDialogState();
}

class _RoleDetailDialogState extends State<RoleDetailDialog> {
  @override
  void initState() {
    super.initState();
    context.read<RoleCubit>().getRoleById(widget.roleId);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 560),
        child: BlocBuilder<RoleCubit, RoleState>(
          // Only rebuild for detail states — ignore list-level states.
          buildWhen: (prev, curr) =>
              curr is RoleDetailLoading ||
              curr is RoleDetailLoaded ||
              curr is RoleDetailError,
          builder: (context, state) {
            if (state is RoleDetailLoading) {
              return const _LoadingView();
            }
            if (state is RoleDetailLoaded) {
              return _DetailContent(role: state.role);
            }
            if (state is RoleDetailError) {
              return _ErrorView(message: state.message, roleId: widget.roleId);
            }
            // Fallback while the first state arrives
            return const _LoadingView();
          },
        ),
      ),
    );
  }
}

// ─── Loading ────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 16),
            Text(
              'Loading role details…',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error ───────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final String roleId;

  const _ErrorView({required this.message, required this.roleId});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                size: 36,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Unable to Load Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined, size: 16),
                    label: const Text('Return to List'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.read<RoleCubit>().getRoleById(roleId),
                    icon: const Icon(Icons.refresh_outlined, size: 16),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appThemeColorLight,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Detail Content ──────────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final RoleEntity role;
  const _DetailContent({required this.role});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ─────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.appThemeColorLight.withValues(
                        alpha: 0.1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: AppColors.appThemeColorLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Role Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── Body ─────────────────────────────────────────────────────────
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic info
                _SectionLabel('ROLE INFO'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _DetailRow(
                      icon: Icons.label_outline_rounded,
                      label: 'Name',
                      value: role.name.isEmpty ? '—' : role.name,
                    ),
                    _DetailRow(
                      icon: Icons.notes_rounded,
                      label: 'Description',
                      value: role.description.isEmpty ? '—' : role.description,
                    ),
                    _DetailRow(
                      icon: role.status == 'ACTIVE'
                          ? Icons.check_circle_outlined
                          : Icons.cancel_outlined,
                      label: 'Status',
                      customValue: Align(
                        alignment: Alignment.centerLeft,
                        child: AppStatusBadge(status: role.status),
                      ),
                      isLast: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // ── Footer ────────────────────────────────────────────────────────
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0F172A),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

/// Card wrapper for grouped rows
class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(children: children),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Color(0xFF94A3B8),
        letterSpacing: 1.0,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? customValue;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.customValue,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: const Color(0xFF94A3B8)),
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
              Expanded(
                child: customValue ??
                    Text(
                      value ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            indent: 14,
            endIndent: 14,
            color: Color(0xFFE2E8F0),
          ),
      ],
    );
  }
}
