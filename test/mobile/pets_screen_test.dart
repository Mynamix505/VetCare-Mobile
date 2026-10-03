import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vetcare_mobile/app.dart';
import 'package:vetcare_mobile/data/repositories/pet_repository.dart';

void main() {
  testWidgets('opens a demo pet and returns to the list', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(VetCareApp(repository: DemoPetRepository(), isDemo: true));
    await tester.pumpAndSettle();
    expect(find.text('Деморежим: показаны вымышленные питомцы.'), findsOneWidget);
    await tester.tap(find.text('Барсик'));
    await tester.pumpAndSettle();
    expect(find.text('Медицинская карта'), findsOneWidget);
    expect(find.text('Демонстрационная карточка'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Мои питомцы'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
