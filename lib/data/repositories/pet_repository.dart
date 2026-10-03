import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../models/pet_model.dart';

abstract interface class PetRepository {
  Future<List<PetModel>> fetchPets();
}

class ApiPetRepository implements PetRepository {
  ApiPetRepository(this._client);

  final Dio _client;

  @override
  Future<List<PetModel>> fetchPets() async {
    final response = await _client.get<Object?>(ApiEndpoints.pets);
    final body = response.data;
    if (body is! Map<String, dynamic> || body['data'] is! List) {
      throw const FormatException('Expected a data array.');
    }
    return (body['data'] as List).map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Expected a pet object.');
      }
      return PetModel.fromJson(item);
    }).toList(growable: false);
  }
}

class DemoPetRepository implements PetRepository {
  @override
  Future<List<PetModel>> fetchPets() async => const [
        PetModel(id: 'demo-1', name: 'Барсик', species: 'Кот', breed: 'Метис'),
        PetModel(id: 'demo-2', name: 'Луна', species: 'Собака', breed: 'Корги'),
      ];
}
