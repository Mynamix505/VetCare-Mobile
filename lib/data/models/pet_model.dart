class PetModel {
  const PetModel({
    required this.id,
    required this.name,
    required this.species,
    this.breed,
  });

  final String id;
  final String name;
  final String species;
  final String? breed;

  factory PetModel.fromJson(Map<String, dynamic> json) {
    String requiredText(String key) {
      final value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Invalid pet field: $key');
      }
      return value.trim();
    }

    final breed = json['breed'];
    if (breed != null && breed is! String) {
      throw const FormatException('Invalid pet field: breed');
    }
    final normalizedBreed = (breed as String?)?.trim();
    return PetModel(
      id: requiredText('id'),
      name: requiredText('name'),
      species: requiredText('species'),
      breed: normalizedBreed == null || normalizedBreed.isEmpty
          ? null
          : normalizedBreed,
    );
  }
}
