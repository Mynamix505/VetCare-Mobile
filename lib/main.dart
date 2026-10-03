import 'package:flutter/material.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'data/repositories/pet_repository.dart';

void main() {
  const isDemo = bool.fromEnvironment('DEMO_MODE', defaultValue: true);
  const baseUrl = String.fromEnvironment('API_BASE_URL');
  WidgetsFlutterBinding.ensureInitialized();
  final PetRepository repository = isDemo
      ? DemoPetRepository()
      : ApiPetRepository(createApiClient(baseUrl));
  runApp(VetCareApp(repository: repository, isDemo: isDemo));
}
