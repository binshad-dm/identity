class PeriodontalChartEndpoints {
  static const String pendingApproval = '/encounters/periodontal-charts/pending-approval';
  
  static String approve(String encounterId, String periodontalChartId) =>
      '/encounters/$encounterId/periodontal-charts/$periodontalChartId/approve';
}
