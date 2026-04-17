import '../entities/property.dart';
import '../repositories/property_repository.dart';

class GetPropertiesUseCase {
  GetPropertiesUseCase(this._repository);
  final PropertyRepository _repository;

  Future<List<Property>> call() => _repository.getProperties();
}

class GetPropertyDetailUseCase {
  GetPropertyDetailUseCase(this._repository);
  final PropertyRepository _repository;

  Future<Property?> call(String id) => _repository.getPropertyById(id);
}

class ToggleSaveUseCase {
  ToggleSaveUseCase(this._repository);
  final PropertyRepository _repository;

  Future<void> call(String propertyId) => _repository.toggleSave(propertyId);
}
