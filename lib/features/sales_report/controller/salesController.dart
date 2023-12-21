import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesControllerProvider = NotifierProvider<SalesController, bool>(
  () => SalesController(),
);

final metalTypeListProvider = StateProvider<List>((ref) {
  return [];
});

final itemListProvider = StateProvider<List>((ref) {
  return [];
});

final categoryListProvider = StateProvider<List>((ref) {
  return [];
});

final modelListProvider = StateProvider<List>((ref) {
  return [];
});

final measurmentListProvider = StateProvider<List>((ref) {
  return [];
});

final salesTypeListProvider = StateProvider<List>((ref) {
  return [];
});

final salesManListProvider = StateProvider<List>((ref) {
  return [];
});

class SalesController extends Notifier<bool> {
  SalesController();

  @override
  build() {
    return false;
  }
}
