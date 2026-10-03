import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/pet_model.dart';

class PetCard extends StatelessWidget {
  const PetCard({super.key, required this.pet, required this.onTap});

  final PetModel pet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: const CircleAvatar(child: Icon(Icons.pets_outlined)),
          title: Text(pet.name, style: AppTextStyles.cardTitle),
          subtitle: Text([pet.species, pet.breed].whereType<String>().join(' · ')),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
