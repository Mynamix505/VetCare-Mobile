import 'package:flutter/material.dart';

import '../../../data/models/pet_model.dart';

class PetDetailsScreen extends StatelessWidget {
  const PetDetailsScreen({super.key, required this.pet, required this.isDemo});

  final PetModel pet;
  final bool isDemo;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(pet.name)),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Icon(Icons.pets, size: 72, color: Color(0xFF16796C)),
                  const SizedBox(height: 24),
                  if (isDemo) const Text('Демонстрационная карточка'),
                  ListTile(title: const Text('Имя'), subtitle: Text(pet.name)),
                  ListTile(title: const Text('Вид'), subtitle: Text(pet.species)),
                  ListTile(
                    title: const Text('Порода'),
                    subtitle: Text(pet.breed ?? 'Не указана'),
                  ),
                  const Divider(),
                  Text('Медицинская карта', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  const Text('История осмотров и вакцинаций пока недоступна.'),
                ],
              ),
            ),
          ),
        ),
      );
}
