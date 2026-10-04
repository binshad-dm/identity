class BatchEndpoints {
  static const String _base = "academics";

  static const String batches = "$_base/batches";
  static const String batchesSelect = "$_base/batches/select";

  static String batchDetails(String id) => "$_base/batches/$id";
  static String batchDeactivate(String id) => "$_base/batches/$id/deactivate";
  static String batchActivate(String id) => "$_base/batches/$id/activate";
}
