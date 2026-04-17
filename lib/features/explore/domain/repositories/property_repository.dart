import '../entities/property.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties();
  Future<Property?> getPropertyById(String id);
  Future<List<Property>> getSavedProperties();
  Future<void> toggleSave(String propertyId);
}
