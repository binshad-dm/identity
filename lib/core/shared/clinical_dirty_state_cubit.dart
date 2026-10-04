import 'package:flutter_bloc/flutter_bloc.dart';

class ClinicalDirtyStateCubit extends Cubit<bool> {
  ClinicalDirtyStateCubit() : super(true);

  void markClean() => emit(false);

  void markDirty() {
    if (!state) {
      emit(true);
    }
  }
}
