import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../components/custom_button.dart';
import '../../components/pet_card.dart';
import '../../state/pets_notifier.dart';
import 'pet_details_screen.dart';

class PetsScreen extends StatelessWidget {
  const PetsScreen({super.key, required this.isDemo});

  final bool isDemo;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PetsNotifier>();
    return Scaffold(
      appBar: AppBar(title: const Text('VetCare')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: RefreshIndicator(
              onRefresh: context.read<PetsNotifier>().load,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(20.w.clamp(16.0, 32.0).toDouble()),
                children: [
                  const Text('Мои питомцы', style: AppTextStyles.title),
                  const SizedBox(height: 8),
                  const Text('Всё о ваших любимцах — в одном месте.'),
                  const SizedBox(height: 20),
                  if (isDemo) ...[
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Деморежим: показаны вымышленные питомцы.'),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (state.status == PetsStatus.loading || state.status == PetsStatus.initial)
                    const Center(child: CircularProgressIndicator())
                  else if (state.status == PetsStatus.failure) ...[
                    Text(state.error!, semanticsLabel: state.error),
                    const SizedBox(height: 16),
                    CustomButton(label: 'Повторить', onPressed: state.load),
                  ] else if (state.pets.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Text('Питомцев пока нет.'),
                    )
                  else
                    for (final pet in state.pets)
                      PetCard(
                        pet: pet,
                        onTap: () => Navigator.of(context).push<void>(
                          MaterialPageRoute(
                            builder: (_) => PetDetailsScreen(pet: pet, isDemo: isDemo),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
