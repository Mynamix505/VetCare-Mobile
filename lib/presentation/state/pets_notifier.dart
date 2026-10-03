import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/models/pet_model.dart';
import '../../data/repositories/pet_repository.dart';

enum PetsStatus { initial, loading, ready, failure }

class PetsNotifier extends ChangeNotifier {
  PetsNotifier(this._repository);

  final PetRepository _repository;
  PetsStatus _status = PetsStatus.initial;
  List<PetModel> _pets = const [];
  String? _error;
  bool _disposed = false;

  PetsStatus get status => _status;
  List<PetModel> get pets => _pets;
  String? get error => _error;

  Future<void> load() async {
    if (_disposed || _status == PetsStatus.loading) return;
    _status = PetsStatus.loading;
    _error = null;
    notifyListeners();
    try {
      final pets = await _repository.fetchPets();
      if (_disposed) return;
      _pets = List.unmodifiable(pets);
      _status = PetsStatus.ready;
    } catch (error) {
      if (_disposed) return;
      _status = PetsStatus.failure;
      _error = switch (error) {
        DioException(response: final response)
            when response?.statusCode == 401 =>
          'Для просмотра питомцев необходимо войти в аккаунт.',
        DioException() =>
          'Не удалось загрузить питомцев. Проверьте соединение и повторите попытку.',
        FormatException() => 'Сервер вернул данные в неподдерживаемом формате.',
        _ => 'Не удалось загрузить питомцев. Попробуйте ещё раз.',
      };
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
