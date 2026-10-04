class ReferralEndpoints {
  static String referrals(String encounterId) => '/encounters/$encounterId/referrals';
  static String updateReason(String referralId) => '/referrals/$referralId/reason';
  static String cancelReferral(String referralId) => '/referrals/$referralId/cancel';

  static const String pendingApprovals = 'referrals/pending-approval';
  static const String pendingReview = 'referrals/pending-review';
  static const String pendingReviewCount = 'referrals/pending-review/count';
  static const String availablePractitioners = 'referrals/available-practitioners';
  static String acceptReferral(String id) => 'referrals/$id/accept';
  static String rejectReferral(String id) => 'referrals/$id/reject';
}
