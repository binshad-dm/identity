import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:identity/core/design/theme/colors.dart';
import 'package:identity/core/design/widgets/app_status_badge.dart';
import 'package:identity/features/user_view/domain/entities/user_detail_entity.dart';
import '../../view_model/user_cubit.dart';
import '../../view_model/user_state.dart';

class UserDetailDialog extends StatelessWidget {
  const UserDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 640),
        child: BlocBuilder<UserCubit, UserState>(
          // Only rebuild when these states change; ignore list-level states.
          buildWhen: (prev, curr) =>
              curr is UserDetailLoading ||
              curr is UserDetailLoaded ||
              curr is UserDetailNotFound ||
              curr is UserError,
          builder: (context, state) {
            if (state is UserDetailLoading) {
              return const _LoadingView();
            }
            if (state is UserDetailLoaded) {
              return _DetailContent(detail: state.detail);
            }
            if (state is UserDetailNotFound) {
              return const _NotFoundView();
            }
            if (state is UserError) {
              return _ErrorView(message: state.message);
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
              'Loading user details…',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Not found ───────────────────────────────────────────────────────────────

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
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
                Icons.person_off_outlined,
                size: 36,
                color: Color(0xFFDC2626),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'User Account Unavailable',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'The selected user account no longer exists\nor has been removed from the system.',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_outlined, size: 16),
                label: const Text('Return to User List'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.appThemeColorLight,
                  side: BorderSide(color: AppColors.appThemeColorLight),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Generic error ───────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

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
                    onPressed: () {
                      final cubit = context.read<UserCubit>();
                      final id = cubit.lastDetailId;
                      if (id != null) cubit.fetchUserDetail(id);
                    },
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

// ─── Detail content ───────────────────────────────────────────────────────────

class _DetailContent extends StatelessWidget {
  final UserDetailEntity detail;
  const _DetailContent({required this.detail});

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
                      Icons.person_outline,
                      color: AppColors.appThemeColorLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'User Details',
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
                // Account info
                _SectionLabel('ACCOUNT INFO'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _DetailRow(
                      icon: Icons.badge_outlined,
                      label: 'Full Name',
                      value: detail.fullName.isEmpty ? '—' : detail.fullName,
                    ),
                    _DetailRow(
                      icon: Icons.account_circle_outlined,
                      label: 'Username',
                      value: '@${detail.userName}',
                    ),
                    _DetailRow(
                      icon: detail.isActive
                          ? Icons.check_circle_outlined
                          : Icons.cancel_outlined,
                      label: 'Status',
                      customValue: Align(
                        alignment: Alignment.centerLeft,
                        child: AppStatusBadge(status: detail.status),
                      ),
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Roles
                _SectionLabel('ASSIGNED ROLES'),
                const SizedBox(height: 8),
                detail.roles.isEmpty
                    ? const Text(
                        'No roles assigned.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      )
                    : Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: detail.roles
                            .map((r) => _RoleChip(role: r))
                            .toList(),
                      ),
                const SizedBox(height: 20),

                // Contact
                _SectionLabel('CONTACT'),
                const SizedBox(height: 8),
                _InfoCard(
                  children: [
                    _DetailRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: detail.email.isEmpty ? '—' : detail.email,
                    ),
                    _DetailRow(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: detail.phoneNumber.isEmpty
                          ? '—'
                          : detail.phoneNumber,
                      isLast: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // // Reference
                // _SectionLabel('REFERENCE'),
                // const SizedBox(height: 8),
                // _InfoCard(
                //   children: [
                //     _DetailRow(
                //       icon: Icons.link_outlined,
                //       label: 'System',
                //       value: detail.referenceSystem.isEmpty
                //           ? '—'
                //           : detail.referenceSystem,
                //     ),
                //     _DetailRow(
                //       icon: Icons.tag_outlined,
                //       label: 'Value',
                //       value: detail.referenceValue.isEmpty
                //           ? '—'
                //           : detail.referenceValue,
                //       isLast: true,
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 16),

                // // Audit
                // _SectionLabel('AUDIT'),
                // const SizedBox(height: 8),
                // _InfoCard(
                //   children: [
                //     _DetailRow(
                //       icon: Icons.person_outline,
                //       label: 'Created By',
                //       value: detail.createdBy.isEmpty ? '—' : detail.createdBy,
                //     ),
                //     _DetailRow(
                //       icon: Icons.calendar_today_outlined,
                //       label: 'Created Date',
                //       value: _formatDate(detail.createdDate),
                //     ),
                //     _DetailRow(
                //       icon: detail.passwordTemporary
                //           ? Icons.lock_clock_outlined
                //           : Icons.lock_outline,
                //       label: 'Password',
                //       value: detail.passwordTemporary
                //           ? 'Temporary — must be changed'
                //           : 'Permanent',
                //       valueColor: detail.passwordTemporary
                //           ? Colors.orange.shade700
                //           : null,
                //       isLast: true,
                //     ),
                //   ],
                // ),
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

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip({required this.role});

  static const _roleColors = {
    'ADMIN': Color(0xFF7C3AED),
    'USER': Color(0xFF0284C7),
    'DOCTOR': Color(0xFF0F766E),
    'SUPPORT': Color(0xFFD97706),
  };

  @override
  Widget build(BuildContext context) {
    final color = _roleColors[role] ?? const Color(0xFF6B7280);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        role,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
