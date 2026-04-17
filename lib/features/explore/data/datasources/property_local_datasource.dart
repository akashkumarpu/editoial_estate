import '../../domain/entities/property.dart';

abstract class PropertyLocalDatasource {
  List<Property> getProperties();
  Property? getPropertyById(String id);
}

class PropertyLocalDatasourceImpl implements PropertyLocalDatasource {
  // Shared saved IDs state (in-memory for demo)
  final Set<String> _savedIds = {};

  static final List<Property> _properties = [
    Property(
      id: 'p1',
      title: 'Ethereal Heights',
      location: 'Indiranagar, Bangalore',
      address: '12th Main Road, Indiranagar, Bangalore',
      price: 12000000,
      priceLabel: '₹1.2 Cr',
      beds: 3,
      sqft: 2450,
      facing: 'North',
      lat: 12.9784,
      lng: 77.6408,
      imageUrl:
          'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&q=80',
      ],
      tag: 'Premium Estate',
      agentName: 'Vikram Rathore',
      agentRating: 4.9,
      agentReviews: 124,
      agentImageUrl:
          'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=200&q=80',
      amenities: ['wifi', 'fitness_center', 'pool', 'local_parking', 'ac_unit'],
      description:
          'Nestled in the heart of Bangalore\'s most vibrant district, this 3-bedroom sanctuary offers an unparalleled blend of editorial aesthetics and urban convenience. Premium finishes, panoramic city views, and concierge-level building management define life at Ethereal Heights.',
      connectivityScore: 9.4,
      isNew: true,
      isSaved: false,
    ),
    Property(
      id: 'p2',
      title: 'Azure Indiranagar Residences',
      location: 'Koramangala, Bangalore',
      address: '5th Block, Koramangala, Bangalore',
      price: 42000000,
      priceLabel: '₹4.2 Cr',
      beds: 4,
      sqft: 3800,
      facing: 'East',
      lat: 12.9352,
      lng: 77.6245,
      imageUrl:
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&q=80',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&q=80',
      ],
      tag: 'Luxury Penthouse',
      agentName: 'Julian Vance',
      agentRating: 4.8,
      agentReviews: 98,
      agentImageUrl:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&q=80',
      amenities: ['wifi', 'fitness_center', 'pool', 'local_parking', 'ac_unit', 'elevator'],
      description:
          'An architectural masterpiece in Koramangala. This 4BHK penthouse spans two floors with floor-to-ceiling windows, private rooftop terrace, and bespoke interiors crafted by award-winning designers.',
      connectivityScore: 9.7,
      isNew: false,
      isSaved: false,
    ),
    Property(
      id: 'p3',
      title: 'Green Canopy Villas',
      location: 'Whitefield, Bangalore',
      address: 'ITPL Main Road, Whitefield, Bangalore',
      price: 8500000,
      priceLabel: '₹85 L',
      beds: 3,
      sqft: 1850,
      facing: 'South',
      lat: 12.9698,
      lng: 77.7499,
      imageUrl:
          'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800&q=80',
        'https://images.unsplash.com/photo-1560184897-ae75f418493e?w=800&q=80',
      ],
      tag: 'New Launch',
      agentName: 'Priya Sharma',
      agentRating: 4.7,
      agentReviews: 67,
      agentImageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200&q=80',
      amenities: ['wifi', 'local_parking', 'ac_unit'],
      description:
          'A thoughtfully designed villa community in Whitefield, surrounded by lush greenery. Perfect for families seeking serenity without compromising on connectivity to the tech corridor.',
      connectivityScore: 8.6,
      isNew: true,
      isSaved: false,
    ),
    Property(
      id: 'p4',
      title: 'The Terrace at MG Road',
      location: 'MG Road, Bangalore',
      address: 'MG Road, Ashok Nagar, Bangalore',
      price: 45000,
      priceLabel: '₹45k/mo',
      beds: 2,
      sqft: 1200,
      facing: 'West',
      lat: 12.9767,
      lng: 77.6009,
      imageUrl:
          'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&q=80',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800&q=80',
      ],
      tag: 'Premium Rental',
      agentName: 'Arjun Mehta',
      agentRating: 4.6,
      agentReviews: 43,
      agentImageUrl:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&q=80',
      amenities: ['wifi', 'fitness_center', 'ac_unit'],
      description:
          'Sophisticated 2BHK rental in the heart of Bangalore\'s commercial district. Walking distance to restaurants, cafes, and metro. Fully furnished with premium appliances.',
      connectivityScore: 9.8,
      isNew: false,
      isSaved: false,
      isRental: true,
      monthlyRent: 45000,
    ),
    Property(
      id: 'p5',
      title: 'Serenity Gardens',
      location: 'HSR Layout, Bangalore',
      address: 'Sector 2, HSR Layout, Bangalore',
      price: 24000000,
      priceLabel: '₹2.4 Cr',
      beds: 4,
      sqft: 2900,
      facing: 'North-East',
      lat: 12.9116,
      lng: 77.6389,
      imageUrl:
          'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800&q=80',
      images: [
        'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800&q=80',
        'https://images.unsplash.com/photo-1583847268964-b28dc8f51f92?w=800&q=80',
      ],
      tag: 'Featured',
      agentName: 'Kavitha Reddy',
      agentRating: 4.9,
      agentReviews: 201,
      agentImageUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=200&q=80',
      amenities: ['wifi', 'fitness_center', 'pool', 'local_parking', 'ac_unit'],
      description:
          'A curated garden estate in HSR Layout featuring a rare 4BHK configuration with private garden, swimming pool, and designated servant quarters. Designed for discerning families who value both luxury and tranquility.',
      connectivityScore: 9.1,
      isNew: false,
      isSaved: false,
    ),
  ];

  @override
  List<Property> getProperties() {
    return _properties.map((p) {
      return _savedIds.contains(p.id) ? p.copyWith(isSaved: true) : p;
    }).toList();
  }

  @override
  Property? getPropertyById(String id) {
    try {
      final p = _properties.firstWhere((p) => p.id == id);
      return _savedIds.contains(p.id) ? p.copyWith(isSaved: true) : p;
    } catch (_) {
      return null;
    }
  }

  void toggleSaved(String id) {
    if (_savedIds.contains(id)) {
      _savedIds.remove(id);
    } else {
      _savedIds.add(id);
    }
  }

  List<Property> getSavedProperties() {
    return _properties
        .where((p) => _savedIds.contains(p.id))
        .map((p) => p.copyWith(isSaved: true))
        .toList();
  }
}
