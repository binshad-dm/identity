import 'package:flutter/widgets.dart';

import 'failure.dart';

String localizeFailure(BuildContext c, Failure f) {
  switch (f.code) {
    case 'auth':
      return "Session expired";
    case 'network':
      return "Server unavailable";
    default:
      return "Unknown error";
  }
}
