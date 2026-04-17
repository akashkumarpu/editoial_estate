import '../../domain/entities/property.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_local_datasource.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  const PropertyRepositoryImpl({required this.datasource});

  final PropertyLocalDatasource datasource;

  @override
  Future<List<Property>> getProperties() async {
    // Simulate network delay for realistic UX
    await Future.delayed(const Duration(milliseconds: 600));
    return datasource.getProperties();
  }

  @override
  Future<Property?> getPropertyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return datasource.getPropertyById(id);
  }

  @override
  Future<List<Property>> getSavedProperties() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return (datasource as PropertyLocalDatasourceImpl).getSavedProperties();
  }

  @override
  Future<void> toggleSave(String propertyId) async {
    (datasource as PropertyLocalDatasourceImpl).toggleSaved(propertyId);
  }
}
