import '../models/calculation.dart';
import '../services/firestore_service.dart';

class HistoryController {
  final FirestoreService _firestoreService = FirestoreService.instance;

  Stream<List<Calculation>> getHistory() {
    return _firestoreService.historyStream();
  }

  Future<void> clearHistory() async {
    await _firestoreService.clearHistory();
  }
}
