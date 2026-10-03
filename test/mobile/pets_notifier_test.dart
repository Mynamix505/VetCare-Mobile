import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vetcare_mobile/data/models/pet_model.dart';
import 'package:vetcare_mobile/data/repositories/pet_repository.dart';
import 'package:vetcare_mobile/presentation/state/pets_notifier.dart';

class ControlledRepository implements PetRepository {
  final requests = <Completer<List<PetModel>>>[];

  @override
  Future<List<PetModel>> fetchPets() {
    final request = Completer<List<PetModel>>();
    requests.add(request);
    return request.future;
  }
}

void main() {
  test('rejects missing identifiers and invalid breed types', () {
    expect(
      () => PetModel.fromJson({'name': 'Луна', 'species': 'Собака'}),
      throwsFormatException,
    );
    expect(
      () => PetModel.fromJson({'id': '1', 'name': 'Луна', 'species': 'Собака', 'breed': 42}),
      throwsFormatException,
    );
    final pet = PetModel.fromJson({'id': '1', 'name': ' Луна ', 'species': 'Собака'});
    expect(pet.name, 'Луна');
    expect(pet.breed, isNull);
  });

  test('coalesces concurrent loads and exposes an immutable list', () async {
    final repository = ControlledRepository();
    final state = PetsNotifier(repository);
    addTearDown(state.dispose);
    final pending = state.load();
    await state.load();
    expect(repository.requests, hasLength(1));
    expect(state.status, PetsStatus.loading);
    repository.requests.single.complete([
      const PetModel(id: '1', name: 'Луна', species: 'Собака'),
    ]);
    await pending;
    expect(state.status, PetsStatus.ready);
    expect(state.pets.single.name, 'Луна');
    expect(() => state.pets.clear(), throwsUnsupportedError);
  });

  test('can retry after failure and accepts an empty list', () async {
    final repository = ControlledRepository();
    final state = PetsNotifier(repository);
    addTearDown(state.dispose);
    final failed = state.load();
    repository.requests.single.completeError(Exception('private server details'));
    await failed;
    expect(state.status, PetsStatus.failure);
    expect(state.error, isNot(contains('private server details')));
    final retry = state.load();
    expect(state.error, isNull);
    repository.requests.last.complete([]);
    await retry;
    expect(state.status, PetsStatus.ready);
    expect(state.pets, isEmpty);
  });

  test('ignores a response after disposal', () async {
    final repository = ControlledRepository();
    final state = PetsNotifier(repository);
    final pending = state.load();
    state.dispose();
    repository.requests.single.complete([]);
    await expectLater(pending, completes);
  });
}
