class AttachmentEndpoints {
  AttachmentEndpoints._();

  static const String _base = 'clinical/patient-attachments';

  // Folders
  static String foldersByPatient(String patientId) =>
      '$_base/patients/$patientId/folders';
  static const String folders = '$_base/folders';
  static String folderById(String id) => '$_base/folders/$id';

  // Attachments inside a folder
  static String attachmentsByFolder(String folderId) =>
      '$_base/folders/$folderId/attachments';

  // Move attachments
  static String get moveAttachments => '$_base/attachments/move';

  // Single attachment operations
  static String attachmentById(String id) => '$_base/attachments/$id';
  static String previewAttachment(String id) => '$_base/attachments/$id/preview';
  static String viewAttachment(String id) => '$_base/attachments/$id/view';
  static String downloadAttachment(String id) =>
      '$_base/attachments/$id/download';
}
